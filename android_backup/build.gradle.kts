allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Correct way to handle build directory in Kotlin DSL
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// FIX: Correct Kotlin syntax for the clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}