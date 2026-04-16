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

    // 2. Clone code-review-skill into .agent/skills
    context.logger.info('Cloning code-review-skill into .agent/skills...');
    final skillsDir = './$projectDirName/.agent/skills';
    final codeReviewSkillDir = '$skillsDir/code-review-skill';
    final skillDir = Directory(codeReviewSkillDir);
    if (await skillDir.exists()) {
      context.logger.info('code-review-skill already exists, skipping clone.');
    } else {
      await Directory(skillsDir).create(recursive: true);
      final cloneResult = await Process.run(
        'git',
        ['clone', 'https://github.com/awesome-skills/code-review-skill', 'code-review-skill'],
        workingDirectory: skillsDir,
        runInShell: true,
      );
      if (cloneResult.exitCode != 0) {
        context.logger.warn('Failed to clone code-review-skill: ${cloneResult.stderr}');
      } else {
        context.logger.success('code-review-skill cloned successfully.');
      }
    }

    // 3. Handle Keystore
    final assetsKeyPath = './$projectDirName/assets/zyycomicrach.jks';
    final androidAppPath = './$projectDirName/android/app';

    final isDefaultFlavor = flavorName == 'zyycomicrach';
    final keystoreFilename = isDefaultFlavor ? 'zyycomicrach.jks' : '$flavorName.jks';
    final keyAlias = isDefaultFlavor ? 'zyycomicrach' : flavorName;
    final keyStorePassword = '123456';
    final keyPassword = '123456';

    final androidKeyPath = '$androidAppPath/$keystoreFilename';

    if (isDefaultFlavor) {
      final keyFile = File(assetsKeyPath);
      if (await keyFile.exists()) {
        await keyFile.copy(androidKeyPath);
        context.logger.info('Keystore copied to $androidKeyPath');
      } else {
        context.logger.warn('Keystore not found at $assetsKeyPath, skipping copy.');
      }
    } else {
      context.logger.info('Generating new keystore for flavor $flavorName...');
      // Generate new keystore
      final keytoolArgs = ['-genkey', '-v', '-keystore', keystoreFilename, '-alias', keyAlias, '-keyalg', 'RSA', '-keysize', '2048', '-validity', '10000', '-storepass', keyStorePassword, '-keypass', keyPassword, '-dname', 'CN=$orgName, OU=$flavorName, O=$orgName, L=Unknown, ST=Unknown, C=Unknown'];

      final keytoolResult = await Process.run('keytool', keytoolArgs, workingDirectory: '$androidAppPath');

      if (keytoolResult.exitCode == 0) {
        context.logger.success('Generated keystore $keystoreFilename');
      } else {
        context.logger.err('Failed to generate keystore: ${keytoolResult.stderr}');
        context.logger.info('Attempting to fallback to copy default keystore...');
        final keyFile = File(assetsKeyPath);
        if (await keyFile.exists()) {
          await keyFile.copy(androidKeyPath);
          context.logger.info('Fallback: Keystore copied to $androidKeyPath');
        }
      }
    }

    // 4. Detect AGP version to decide packaging vs packagingOptions
    final agpVersion = await _detectAgpVersion('./$projectDirName/android');
    final isAgp8OrAbove = _isAgp8OrAbove(agpVersion);
    final packagingKeyword = isAgp8OrAbove ? 'packaging' : 'packagingOptions';
    context.logger.info('Detected AGP version: ${agpVersion ?? "unknown"}, using "$packagingKeyword"');

    // 5. Update build.gradle.kts
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
      final config = _androidConfig
          .replaceAll('{{FLAVOR_NAME}}', flavorName)
          .replaceAll('{{APP_DISPLAY_NAME}}', appDisplayName)
          .replaceAll('{{ORG_NAME}}', orgName)
          .replaceAll('{{PROJECT_NAME_SNAKE}}', _toSnakeCase(projectName))
          .replaceAll('{{KEYSTORE_FILE}}', keystoreFilename)
          .replaceAll('{{KEY_ALIAS}}', keyAlias)
          .replaceAll('{{PACKAGING_KEYWORD}}', packagingKeyword);

      await buildFile.writeAsString(config, mode: FileMode.append);
      context.logger.info('Updated ${buildFile.path} with custom configurations');
    } else {
      context.logger.warn('No build.gradle(.kts) found in $androidAppPath');
    }

    // 6. Update AndroidManifest.xml
    final manifestFile = File('$androidAppPath/src/main/AndroidManifest.xml');
    if (await manifestFile.exists()) {
      var content = await manifestFile.readAsString();
      // Replace label and icon with placeholders
      // Note: We escape ${String} because we want literally ${appName} in the XML (if using manifestPlaceholders)
      // Actually, standard Android manifesto placeholders use ${name}.
      content = content.replaceAll(RegExp(r'android:label="[^"]*"'), 'android:label="\${appName}"');
      content = content.replaceAll(RegExp(r'android:icon="[^"]*"'), 'android:icon="\${icon}"');

      // Inject required permissions after <manifest ...> tag
      final permissionsBlock = '''
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />''';

      // Insert permissions after the <manifest> opening tag, before <application>
      if (!content.contains('android.permission.CAMERA')) {
        final manifestMatch = RegExp(r'<manifest[^>]*>').firstMatch(content);
        if (manifestMatch != null) {
          final manifestTag = manifestMatch.group(0)!;
          content = content.replaceFirst(
            manifestTag,
            '$manifestTag\n$permissionsBlock\n',
          );
        }
        context.logger.info('Injected Android permissions into AndroidManifest.xml');
      } else {
        context.logger.info('Permissions already present in AndroidManifest.xml, skipping injection.');
      }

      await manifestFile.writeAsString(content);
      context.logger.info('Updated AndroidManifest.xml with placeholders');
    }

    // 7. Run generate_icons
    context.logger.info('Running generate_icons for flavor: $flavorName');
    final generateIconsResult = await Process.run('dart', ['tool/generate_icons.dart', '-f', 'flutter_launcher_${flavorName}_icons.yaml'], workingDirectory: './$projectDirName', runInShell: true);

    if (generateIconsResult.exitCode != 0) {
      context.logger.err(generateIconsResult.stderr);
      context.logger.warn('Failed to generate icons. You may need to run this manually.');
    } else {
      context.logger.info(generateIconsResult.stdout);
      context.logger.success('Icons generated successfully.');
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
            storeFile = file("{{KEYSTORE_FILE}}")
            storePassword = "123456"
            keyAlias = "{{KEY_ALIAS}}"
            keyPassword = "123456"
        }
        create("{{FLAVOR_NAME}}") {
            storeFile = file("{{KEYSTORE_FILE}}")
            storePassword = "123456"
            keyAlias = "{{KEY_ALIAS}}"
            keyPassword = "123456"
        }
    }

    {{PACKAGING_KEYWORD}} {
        dex {
            useLegacyPackaging = true
        }
        jniLibs {
            useLegacyPackaging = true
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
            
            {{PACKAGING_KEYWORD}} {
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

/// Detect AGP version from the project-level gradle files.
/// Searches in settings.gradle(.kts) and build.gradle(.kts) for the AGP version.
Future<String?> _detectAgpVersion(String androidDir) async {
  // Search patterns for AGP version in different gradle file formats
  final filesToCheck = [
    '$androidDir/settings.gradle.kts',
    '$androidDir/settings.gradle',
    '$androidDir/build.gradle.kts',
    '$androidDir/build.gradle',
  ];

  // Patterns to match AGP version declaration
  // settings.gradle.kts: id("com.android.application") version "8.1.0" apply false
  // build.gradle.kts:    classpath("com.android.tools.build:gradle:7.4.2")
  // settings.gradle:     id 'com.android.application' version '8.1.0' apply false
  // build.gradle:        classpath 'com.android.tools.build:gradle:7.4.2'
  final patterns = [
    // Settings: id "com.android.application" version "X.Y.Z"
    RegExp(r'''id\s*[(\s]*["']com\.android\.application["']\s*[)\s]*\s*version\s*[(\s]*["'](\d+\.\d+[^"']*)["']'''),
    // Classpath: com.android.tools.build:gradle:X.Y.Z
    RegExp(r'''com\.android\.tools\.build:gradle:(\d+\.\d+[^"']*)["']'''),
    // libs.plugins style or variable reference — try to find agp version in version catalog
    RegExp(r'''agp\s*=\s*["'](\d+\.\d+[^"']*)["']'''),
  ];

  for (final filePath in filesToCheck) {
    final file = File(filePath);
    if (await file.exists()) {
      final content = await file.readAsString();
      for (final pattern in patterns) {
        final match = pattern.firstMatch(content);
        if (match != null) {
          return match.group(1);
        }
      }
    }
  }

  // Also check gradle/libs.versions.toml for version catalog
  final versionCatalog = File('$androidDir/gradle/libs.versions.toml');
  if (await versionCatalog.exists()) {
    final content = await versionCatalog.readAsString();
    final match = RegExp(r'''agp\s*=\s*["'](\d+\.\d+[^"']*)["']''').firstMatch(content);
    if (match != null) {
      return match.group(1);
    }
  }

  return null;
}

/// Check if AGP version is 8.0.0 or above.
/// Defaults to true (use `packaging`) if version cannot be determined,
/// since newer Flutter projects typically use AGP 8+.
bool _isAgp8OrAbove(String? version) {
  if (version == null) return true; // Default to AGP 8+ for newer projects
  final parts = version.split('.');
  if (parts.isEmpty) return true;
  final major = int.tryParse(parts[0]);
  if (major == null) return true;
  return major >= 8;
}
