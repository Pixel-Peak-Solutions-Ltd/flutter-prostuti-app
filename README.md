# prostuti

##### To run the app project first install ***fvm*** on your system.

***for IOS build it's preferred to archive from xCode and upload the symbol files to as well.***

## run:

```
fvm use 3.24.3

```

```
configure Appwrite credantials and setup the Appwrite project on this device
```

```
fvm flutter pub get
flutter pub run build_runner watch --delete-conflicting-outputs
fvm flutter run
mason get
mason make pros
```

## To give build for Android

```
# Development APK (Android)
flutter build apk --flavor development --release -t lib/main_development.dart
   
# Staging APK (Android)
flutter build apk --flavor staging --release -t lib/main_staging.dart
   
# Production APK (Android)
flutter build apk --flavor production --release -t lib/main_production.dart


```

## for IOS build

```
# For iOS apps
flutter build ipa --flavor production -t lib/main_production.dart
```

## for IOS upload-symbols

```
Pods/FirebaseCrashlytics/upload-symbols -gsp Runner/GoogleService-Info.plist -p ios build/Runner.xcarchive/dSYMs
```
 