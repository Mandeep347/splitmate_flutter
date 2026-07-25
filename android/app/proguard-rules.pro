# Flutter Wrapper Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }
-keep class io.flutter.plugins.** { *; }

# Ignore warnings for optional Google Play SplitCompat referenced by Flutter Engine
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Keep native C/C++ or JNI methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Flutter Secure Storage
-keep class com.it_neer.flutter_secure_storage.** { *; }
