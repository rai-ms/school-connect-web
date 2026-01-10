import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("app")

    productFlavors {
        create("dev") {
            dimension = "app"
            applicationId = "com.student.connect.student_management.dev"
            resValue(type = "string", name = "app_name", value = "School Connect Dev")
        }
        create("prod") {
            dimension = "app"
            applicationId = "com.student.connect.student_management"
            resValue(type = "string", name = "app_name", value = "School Connect")
        }
    }
}