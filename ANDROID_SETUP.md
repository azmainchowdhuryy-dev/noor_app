# Android সেটআপ (লোকেশনের জন্য)

android/app/src/main/AndroidManifest.xml ফাইলে <manifest> ট্যাগের ভেতরে,
<application> ট্যাগের আগে যোগ করুন:

    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>

তারপর: flutter pub get  →  flutter run
