plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.aero_template_reference"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    // Default configuration
    defaultConfig {
        applicationId = "com.example.aero_template_reference"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Signing Configurations
    signingConfigs {
        create("release") {
            storeFile = file("zyycomicrach.jks")
            storePassword = "123456"
            keyAlias = "zyycomicrach"
            keyPassword = "123456"
        }
        create("zyycomicrach") {
            storeFile = file("zyycomicrach.jks")
            storePassword = "123456"
            keyAlias = "zyycomicrach"
            keyPassword = "123456"
        }
    }

    // Build Types
    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("zyycomicrach")
        }
        getByName("release") {
            // Native library packaging options
            ndk {
                abiFilters.clear()
                abiFilters.addAll(listOf("arm64-v8a", "armeabi-v7a"))
            }

            signingConfig = signingConfigs.getByName("zyycomicrach")
            
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

    // Flavor Dimensions
    flavorDimensions += "version"
    productFlavors {
        create("zyycomicrach") {
            dimension = "version"
            applicationId = "com.zyycomicrach.www"
            manifestPlaceholders["CHANNEL_VALUE"] = "YCZSJL001"
            manifestPlaceholders["appName"] = "漫剧大师"
            manifestPlaceholders["icon"] = "@mipmap/launcher_icon"
            resValue("string", "app_logo", "launcher_icon") // Using string resource for safety? User used resValue("mipmap"...)
            // User snippet: resValue("mipmap", "app_logo", "@mipmap/launcher_icon")
            // In Kotlin DSL, resValue is (type, name, value). 
            resValue("mipmap", "app_logo", "@mipmap/launcher_icon") 
            signingConfig = signingConfigs.getByName("zyycomicrach")
        }
    }

    // Application Variants (Output Filename)
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

flutter {
    source = "../.."
}
