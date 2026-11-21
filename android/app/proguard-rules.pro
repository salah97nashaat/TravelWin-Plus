# Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.**  { *; }

# For In-App Purchase / Billing Client
-keep class com.android.billingclient.** { *; }

# For Firebase
-keep class com.google.firebase.** { *; }

# For Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }

# For Google Sign-In
-keep class com.google.android.gms.auth.api.signin.** { *; }

# Suppress missing reference warnings
-dontwarn **
