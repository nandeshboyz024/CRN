# Connected Ride Network (CRN)

A real-time group ride coordination mobile app built with Flutter. Designed for motorcycle groups, cyclists, trekking teams, and convoys to stay connected during a ride.

---

## Features

- Live map with rider markers (OpenStreetMap, no API key needed)
- Real-time connectivity detection between riders
- Automatic split/group detection with alerts
- Route planning and route display
- Rider status dashboard with speed and progress
- Group management
- Collapsible bottom panel on the ride screen
- Dark theme UI

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter (Dart) |
| Maps | flutter_map + OpenStreetMap |
| State | Provider |
| Backend *(planned)* | Spring Boot 3, Java 21 |
| Database *(planned)* | PostgreSQL + PostGIS |
| Real-time *(planned)* | WebSocket |
| Notifications *(planned)* | Firebase Cloud Messaging |

> This version uses **dummy/simulated data**. No real backend is connected yet.

---

## Prerequisites

Make sure the following are installed on your machine:

| Tool | Minimum Version | Download |
|---|---|---|
| Flutter SDK | 3.12+ | https://docs.flutter.dev/get-started/install |
| Dart SDK | Bundled with Flutter | — |
| Android Studio | Latest | https://developer.android.com/studio |
| Android SDK | API 21+ | Via Android Studio SDK Manager |
| Git | Any | https://git-scm.com |

Verify your setup by running:
```bash
flutter doctor
```
Fix any issues it reports before continuing.

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/connected-ride-network.git
cd connected-ride-network
```

### 2. Install Flutter dependencies

```bash
flutter pub get
```

### 3. Connect a device

**Option A — Physical Android phone:**
1. On your phone go to **Settings → About Phone**
2. Tap **Build Number** 7 times to unlock Developer Options
3. Go to **Settings → Developer Options** and enable **USB Debugging**
4. Connect your phone to the computer via USB
5. Run `flutter devices` — your phone should appear in the list

**Option B — Android Emulator:**
1. Open **Android Studio → Virtual Device Manager**
2. Click **Create Device**, choose Pixel 6, API 33
3. Start the emulator
4. Run `flutter devices` to confirm it's detected

### 4. Run the app

**Option A — Terminal:**
```bash
flutter run
```

If multiple devices are connected, pick one:
```bash
flutter run -d <device-id>
```

**Option B — VS Code:**
1. Install the **Flutter** extension from the VS Code Marketplace (`Dart-Code.flutter`)
2. Open this project folder in VS Code: **File → Open Folder**
3. Select your target device from the status bar at the bottom right (e.g. an emulator or connected phone)
4. Press **F5** (or go to **Run → Start Debugging**) to build and launch the app

The app will build and launch automatically on your device.

---

## Project Structure

```
lib/
  main.dart                      # App entry point, theme, Provider setup
  models/
    models.dart                  # Data classes: User, Group, Ride, RiderLocation
  data/
    dummy_data.dart              # Simulated riders, groups, route coordinates
  providers/
    ride_provider.dart           # State + connectivity algorithm + simulation timer
  screens/
    splash_screen.dart           # Animated launch screen
    login_screen.dart            # Login with dummy user selection
    home_screen.dart             # Dashboard, Groups, Profile tabs
    groups_screen.dart           # List of ride groups
    create_group_screen.dart     # Form to create a new group
    group_detail_screen.dart     # Group members + Start Ride button
    create_ride_screen.dart      # Ride name, destination, threshold config
    active_ride_screen.dart      # Live map + rider markers + split panel
    rider_dashboard_screen.dart  # Rider status table by component
```

---

## How the Connectivity Algorithm Works

Every 4 seconds the app runs this algorithm:

1. All rider positions are updated (simulated GPS movement)
2. Riders are sorted by **route progress** (distance traveled along the route)
3. The **gap** between each pair of consecutive riders is calculated in meters
4. If any gap exceeds the **connectivity threshold** (default: 200 m), a split is detected
5. Riders are grouped into **components** — Component A (front group), B (back group), etc.
6. Markers on the map are color-coded: green = Component A, red = Component B
7. A banner and bottom panel show the split status in real time

---

## Demo Users

Six pre-loaded dummy riders are available. On the login screen, tap any name chip to switch:

| Name | Color |
|---|---|
| Rahul Sharma | Red (default) |
| Priya Mehta | Purple |
| Arjun Singh | Blue |
| Sneha Nair | Green |
| Vikram Patel | Orange |
| Kavya Reddy | Teal |

---

## Build a Release APK

```bash
flutter build apk --release
```

Output file: `build/app/outputs/flutter-apk/app-release.apk`

Transfer this file to any Android phone and install it directly.

---

## Troubleshooting

**Map tiles not loading**
- Confirm `INTERNET` permission exists in `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  ```
- Check that the device/emulator has an active internet connection

**`flutter pub get` fails**
- Run `flutter doctor` and resolve any reported issues
- Try `flutter clean` then `flutter pub get` again

**No devices found**
- Physical device: verify USB Debugging is enabled and the cable supports data (not charge-only)
- Emulator: make sure it is fully booted before running `flutter run`

**Build errors after pulling changes**
```bash
flutter clean
flutter pub get
flutter run
```

---

## License

MIT License — free to use and modify.