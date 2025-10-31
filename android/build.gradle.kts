// build.gradle.kts del proyecto raíz

plugins {
    // Plugin de Android solo se aplica en los módulos, no aquí
    id("com.android.application") apply false
    // Plugin de Google Services para Firebase / Google Sign-In
    id("com.google.gms.google-services") version "4.4.4" apply false
    // Plugin de Kotlin solo se aplica en los módulos
    id("org.jetbrains.kotlin.android") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Configuración opcional de directorios de build
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
