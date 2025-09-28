allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // Suppress Java 8 warnings and deprecation warnings from dependencies
    tasks.withType<JavaCompile> {
        options.compilerArgs.addAll(listOf("-Xlint:-options", "-Xlint:-deprecation"))
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
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