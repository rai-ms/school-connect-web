# Keep Firebase + Guava annotations
-keep class com.google.j2objc.annotations.** { *; }
-dontwarn com.google.j2objc.annotations.**

# Keep Firebase Crashlytics
-keepattributes SourceFile,LineNumberTable
-keep class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**

# Keep Firebase Analytics
-keep class com.google.firebase.analytics.** { *; }
-dontwarn com.google.firebase.analytics.**
