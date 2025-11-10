plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Firebase / Google Sign-In
}

android {
    namespace = "com.example.vibra_project"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.vibra_project"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false       // Desactivamos code shrinking para evitar errores
            isShrinkResources = false     // Desactivamos eliminar recursos no usados
            // Si quieres habilitar shrinking, activa lo siguiente y crea proguard-rules.pro
            /*
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            */
        }
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
}

dependencies {
    implementation("com.google.android.gms:play-services-auth:20.7.0") // Google Sign-In
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}

flutter {
    source = "../.."
}
