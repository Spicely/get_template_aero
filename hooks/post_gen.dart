import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final progress = context.logger.progress('Initializing template...');
  final orgName = context.vars['org_name'];
  final projectName = context.vars['project_name'] as String;
  final appDisplayName = context.vars['app_display_name'] as String;
  final flavorName = context.vars['flavor_name'] as String;

  final projectDirName = _toSnakeCase(projectName);

  try {
    context.logger.info('================  Start Template Initialization  ======================');

    // 1. Run flutter create
    final result = await Process.run('flutter', ['create', '.', '--org', orgName], workingDirectory: './$projectDirName', runInShell: true);

    if (result.exitCode != 0) {
      context.logger.err(result.stderr);
      progress.fail('================  Template Initialization Failed (flutter create)  ======================');
      exit(result.exitCode);
    }
    context.logger.info(result.stdout);

    // 2. Copy Keystore
    final assetsKeyPath = './$projectDirName/assets/zyycomicrach.jks';
    final androidAppPath = './$projectDirName/android/app';
    // Use fixed filename if flavorName matches default, or maybe just always use zyycomicrach.jks for now?
    // Code below expects zyycomicrach.jks in build.gradle config.
    // If we want to rename it based on flavor, we should do it here.
    // However, the keystore ALIAS inside the .jks file is 'zyycomicrach'.
    // Changing the filename is fine, but changing the alias in build.gradle won't match the key inside the jks file.
    // Since we cannot change the key alias inside the binary jks, we should probably keep the keystore filename standard
    // OR just use the provided flavorName and assume the user will replace the keystore later.
    // For now, let's keep the filename as is if possible, OR rename it if consistent.
    // Given the user wants to change 'signature', they likely want to customize the CONFIG.
    // We will keep 'zyycomicrach.jks' as the file source, but we can copy it to whatever filename we want?
    // No, let's keep it simple: copy as zyycomicrach.jks.
    // And in build.gradle, we use THAT filename.
    final androidKeyPath = '$androidAppPath/zyycomicrach.jks';

    final keyFile = File(assetsKeyPath);
    if (await keyFile.exists()) {
      await keyFile.copy(androidKeyPath);
      context.logger.info('Keystore copied to $androidKeyPath');
    } else {
      context.logger.warn('Keystore not found at $assetsKeyPath, skipping copy.');
    }

    // 3. Update build.gradle.kts
    final buildFileKts = File('$androidAppPath/build.gradle.kts');
    final buildFileGroovy = File('$androidAppPath/build.gradle');

    File? buildFile;
    if (await buildFileKts.exists()) {
      buildFile = buildFileKts;
    } else if (await buildFileGroovy.exists()) {
      buildFile = buildFileGroovy;
    }

    if (buildFile != null) {
      // Replace placeholders in the config string
      final config = _androidConfig.replaceAll('{{FLAVOR_NAME}}', flavorName).replaceAll('{{APP_DISPLAY_NAME}}', appDisplayName).replaceAll('{{ORG_NAME}}', orgName).replaceAll('{{PROJECT_NAME_SNAKE}}', _toSnakeCase(projectName));

      await buildFile.writeAsString(config, mode: FileMode.append);
      context.logger.info('Updated ${buildFile.path} with custom configurations');
    } else {
      context.logger.warn('No build.gradle(.kts) found in $androidAppPath');
    }

    // 4. Update AndroidManifest.xml
    final manifestFile = File('$androidAppPath/src/main/AndroidManifest.xml');
    if (await manifestFile.exists()) {
      var content = await manifestFile.readAsString();
      // Replace label and icon with placeholders
      // Note: We escape ${String} because we want literally ${appName} in the XML (if using manifestPlaceholders)
      // Actually, standard Android manifesto placeholders use ${name}.
      content = content.replaceAll(RegExp(r'android:label="[^"]*"'), 'android:label="\${appName}"');
      content = content.replaceAll(RegExp(r'android:icon="[^"]*"'), 'android:icon="\${icon}"');

      await manifestFile.writeAsString(content);
      context.logger.info('Updated AndroidManifest.xml with placeholders');
    }

    progress.complete();
    context.logger.success('================  Template Initialization Success  ======================');
  } catch (e) {
    progress.fail('================  Template Initialization Failed  ======================\n $e');
    exit(1);
  }
}

String _toSnakeCase(String str) {
  return str.replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}').replaceAll(RegExp(r'^_'), '').toLowerCase();
}

// Config content to append.
// Uses {{PLACEHOLDERS}} that we manually replace in Dart code.
const _androidConfig = r'''

android {
    signingConfigs {
        create("release") {
            storeFile = file("zyycomicrach.jks")
            storePassword = "123456"
            keyAlias = "zyycomicrach"
            keyPassword = "123456"
        }
        create("{{FLAVOR_NAME}}") {
            storeFile = file("zyycomicrach.jks")
            storePassword = "123456"
            keyAlias = "zyycomicrach"
            keyPassword = "123456"
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("{{FLAVOR_NAME}}")
        }
        getByName("release") {
            // Native library packaging options
            ndk {
                abiFilters.clear()
                abiFilters.addAll(listOf("arm64-v8a", "armeabi-v7a"))
            }

            signingConfig = signingConfigs.getByName("{{FLAVOR_NAME}}")
            
            packaging {
                jniLibs {
                    pickFirsts += listOf(
                        "**/libc++_shared.so",
                        "**/libfbjni.so",
                        "**/libjsc.so"
                    )
                    useLegacyPackaging = true
                }
            }

            manifestPlaceholders["applicationName"] = "android.app.Application"
            
            // Proguard / Shrinking
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            isMinifyEnabled = true 
            isShrinkResources = true 
        }
    }

    flavorDimensions += "version"
    productFlavors {
        create("{{FLAVOR_NAME}}") {
            dimension = "version"
            // Ensure this appId logic is correct for your needs.
            applicationId = "{{ORG_NAME}}.{{PROJECT_NAME_SNAKE}}" 
            manifestPlaceholders["CHANNEL_VALUE"] = "YCZSJL001"
            manifestPlaceholders["appName"] = "{{APP_DISPLAY_NAME}}"
            manifestPlaceholders["icon"] = "@mipmap/launcher_icon"
            resValue("string", "app_logo", "launcher_icon")
            resValue("mipmap", "app_logo", "@mipmap/launcher_icon") 
            signingConfig = signingConfigs.getByName("{{FLAVOR_NAME}}")
        }
    }

    applicationVariants.configureEach {
        val variant = this
        outputs.configureEach {
            val outputImpl = this as com.android.build.gradle.internal.api.ApkVariantOutputImpl
            val flavorName = variant.flavorName
            val versionName = variant.versionName
            val versionCode = variant.versionCode
            val buildTypeName = variant.buildType.name
            val appId = variant.applicationId
            
            outputImpl.outputFileName = "${flavorName}_(${versionName})_[${appId}]_${versionCode}_${buildTypeName}.apk"
        }
    }
}
''';
