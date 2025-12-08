# Astro.FM — Flutter Starter (V 4.0)

This is a small cross-platform Flutter starter app targeting Android, iOS, Web, and Windows. It includes a minimal UI, a widget test, and recommended dependencies for later Firebase and Riverpod integration.

Run locally (PowerShell):

```powershell
cd C:\Astro.FM\astro_fm_app
flutter pub get
flutter doctor -v
flutter devices
flutter run -d chrome    # run on web (Chrome)
flutter run -d windows   # run on Windows desktop
flutter run -d <ANDROID_DEVICE_ID>
flutter test
```

Notes:
- iOS builds require a Mac with Xcode.
- Add your Firebase config files later (`google-services.json`, `GoogleService-Info.plist`).

Recommended repo URL (no dot): `https://github.com/Palazques/AstroFM`
