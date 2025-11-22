# LogLife

**LogLife** is a comprehensive personal productivity application that seamlessly integrates diary journaling, intelligent reminder management, and real-time weather tracking into a unified mobile experience. Built with Flutter and powered by Firebase, LogLife helps users organize their daily lives through an intuitive, feature-rich interface.

---

## 📥 Download APK

**For Recruiters & Evaluators:**

Download the latest release APK:

- **[Download LogLife APK](https://github.com/jerwinagustin/PersonalApplication/raw/main/build/app/outputs/apk/release/app-release.apk)** _(Direct download - 20MB)_

**Alternative Download Options:**

- Check [GitHub Releases](https://github.com/jerwinagustin/PersonalApplication/releases) for versioned APK downloads
- APK is located at: `build/app/outputs/apk/release/app-release.apk`

> **For Developers:** To create a GitHub Release:
>
> 1. Go to your repository → Releases → Create a new release
> 2. Upload `app-release.apk` as a release asset
> 3. This provides a permanent download link independent of repository changes

---

## 🎯 Features Overview

### 📖 **Diary Management**

- **Calendar-Based Journaling**: Organize diary entries by date with an intuitive calendar interface
- **Rich Text Entries**: Create detailed notes with titles, genres/categories, and timestamps
- **Daily View & Navigation**: Browse entries by date with custom calendar modal navigation
- **CRUD Operations**: Full create, read, update, and delete functionality for all diary entries
- **Real-time Sync**: All entries automatically sync with Firebase Firestore

### ⏰ **Smart Reminder System**

- **Multi-Tier Notifications**:
  - 1 hour before reminder time
  - 30 minutes before reminder time
  - Exact due time with alarm-style alerts (Android)
- **Timezone Intelligence**: Automatic device timezone detection using `flutter_timezone`
- **Calendar Integration**: Visual reminder management with `table_calendar` widget
- **Intelligent Scheduling**: Past-time filtering with immediate alerts for overdue reminders
- **Persistent Notifications**: Follow-up alerts on iOS/macOS (10 notifications at 1-minute intervals)
- **Quick Actions**: "Mark Done" action buttons for instant reminder dismissal

### 🌤️ **Weather Integration**

- **Location-Based Forecasts**: Automatic current location detection via `geolocator`
- **Real-Time Weather**: Current temperature, conditions, and humidity from OpenWeatherMap API
- **7-Day Forecast**: Extended weather predictions with daily temperature ranges
- **Animated Weather Icons**: Lottie animations for various weather conditions (sunny, rainy, cloudy, thunderstorm, etc.)
- **Detailed Metrics**: Wind speed, "feels like" temperature, and atmospheric conditions

### 🔐 **Authentication & Security**

- **Firebase Authentication**: Secure email/password login and registration
- **Google Sign-In**: One-tap authentication with Google accounts
- **Password Recovery**: Email-based password reset functionality
- **Session Management**: Persistent authentication state with automatic routing

---

## 🏗️ Architecture

LogLife follows a **modular, feature-based architecture** with clear separation of concerns:

```
lib/
├── main.dart                    # Application entry point
├── firebase_options.dart        # Firebase configuration
├── Auth/                        # Authentication module
│   ├── AuthLayout.dart         # Auth state routing wrapper
│   └── Authservice.dart        # Firebase Auth service layer
├── DiaryPage/                   # Diary feature module
│   ├── Diary.dart              # Main diary view with calendar
│   ├── DiaryNote.dart          # Note creation screen
│   └── Update_Delete.dart      # Note editing screen
├── DiaryDatabase/               # Diary data layer
│   └── DiaryCRUD.dart          # Firestore operations for diary
├── Reminder/                    # Reminder feature module
│   ├── ReminderScreen.dart     # Reminder calendar view
│   └── reminderTime.dart       # Reminder creation/editing
├── Reminder_Call/               # Reminder business logic
│   ├── reminder_model.dart     # Reminder data model
│   └── reminder_service.dart   # Firestore operations for reminders
├── Notifications/               # Notification system
│   └── notification_service.dart # Local notification scheduling
├── Weather/                     # Weather feature module
│   ├── WeatherScreen.dart      # Weather display UI
│   ├── weatherService.dart     # Weather API service
│   └── weather_api_fetch.dart  # Weather data models
├── LoginPage/                   # Login/Registration UI
├── LogoutPage/                  # Logout confirmation
├── NavigationBar/               # Bottom navigation bar
│   └── Navigation.dart         # Main navigation controller
└── Responsiveness/              # Responsive design utilities
```

### Data Flow Architecture

```
User Interface (Flutter Widgets)
        ↓
Service Layer (Auth, Diary, Reminder, Weather Services)
        ↓
Firebase Backend (Authentication, Firestore, Realtime Database)
        ↓
Local Notifications (flutter_local_notifications)
```

---

## 🛠️ Technology Stack

### **Frontend Framework**

- **Flutter SDK**: ^3.8.1 (Cross-platform mobile development)
- **Dart**: Language for Flutter development

### **Backend & Cloud Services**

- **Firebase Core**: ^4.0.0 (Firebase SDK initialization)
- **Firebase Authentication**: ^6.0.0 (User authentication)
- **Cloud Firestore**: ^6.0.0 (NoSQL database for diary entries)
- **Firebase Realtime Database**: ^12.0.0 (Real-time data sync for reminders)

### **Core Dependencies**

- **google_sign_in**: ^6.2.0 (Google OAuth authentication)
- **flutter_local_notifications**: ^17.1.2 (Local push notifications)
- **timezone**: ^0.9.2 (Timezone data and calculations)
- **flutter_timezone**: ^5.0.1 (Device timezone detection)
- **geolocator**: ^14.0.2 (GPS location services)
- **geocoding**: ^4.0.0 (Address geocoding)
- **http**: ^1.5.0 (HTTP client for weather API)

### **UI Components**

- **table_calendar**: ^3.2.0 (Calendar widget for diary/reminders)
- **lottie**: ^3.3.1 (Animated weather icons)
- **material_symbols_icons**: ^4.2858.1 (Material Design 3 icons)
- **google_nav_bar**: ^5.0.7 (Bottom navigation bar)
- **intl**: ^0.20.2 (Internationalization and date formatting)

### **External APIs**

- **OpenWeatherMap API**: Real-time weather data and 7-day forecasts

---

## 📱 Application Screens

1. **Authentication Flow**

   - Loading Screen (Firebase initialization)
   - Login/Register Screen
   - Forgot Password Screen

2. **Main Navigation** (Bottom Tab Bar)

   - **Diary Tab**: Calendar view with daily entries
   - **Weather Tab**: Current weather and 7-day forecast
   - **Reminder Tab**: Calendar-based reminder management
   - **Logout Tab**: Account settings and logout

3. **Diary Module**

   - Diary Calendar View
   - Create New Entry
   - View/Edit Entry
   - Delete Confirmation

4. **Reminder Module**

   - Reminder Calendar View
   - Create New Reminder
   - Edit Reminder
   - Delete Reminder
   - Notification Previews

5. **Weather Module**
   - Current Weather Display
   - 7-Day Forecast List
   - Animated Weather Conditions

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.8.1 or higher
- **Dart SDK**: ^3.8.1
- **Android Studio** / **Xcode** (for mobile development)
- **Firebase Account**: For backend services
- **OpenWeatherMap API Key**: For weather functionality

### Installation Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/jerwinagustin/PersonalApplication.git
   cd PersonalApplication
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**

   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable **Authentication** (Email/Password & Google Sign-In)
   - Enable **Cloud Firestore** database
   - Enable **Firebase Realtime Database**
   - Download `google-services.json` (Android) and place in `android/app/`
   - Download `GoogleService-Info.plist` (iOS) and place in `ios/Runner/`
   - Run Firebase configuration:
     ```bash
     flutterfire configure
     ```

4. **OpenWeatherMap API Setup**

   - Register at [OpenWeatherMap](https://openweathermap.org/api)
   - Obtain API key
   - Replace the API key in `lib/Weather/weatherService.dart`:
     ```dart
     final _weatherService = Weatherservice('YOUR_API_KEY_HERE');
     ```

5. **Run the Application**

   ```bash
   # Debug mode
   flutter run

   # Release mode (Android)
   flutter run --release
   ```

6. **Build APK**
   ```bash
   flutter build apk --release
   ```
   The APK will be generated at: `build/app/outputs/apk/release/app-release.apk`

---

## 🔔 Reminder Notification System

### Notification Triggers

LogLife schedules **three distinct notifications** for each reminder:

1. **1 Hour Before**: Early warning notification
2. **30 Minutes Before**: Preparation notification
3. **Exact Due Time**: Alarm-style notification (Android)

### Technical Implementation

#### Timezone Handling

- Uses `intl` package for time parsing (`h:mm a` format, e.g., "10:00 PM")
- `flutter_timezone` detects device's local timezone
- `timezone` package handles timezone calculations
- Filters out past times; shows immediate alert if due time has passed

#### Notification IDs

- IDs derived from Firestore reminder ID (hashed & constrained to 32-bit range)
- Small offsets applied (`+1`, `+2`, `+3`, `+100 + i`) to prevent collisions
- Prevents native platform errors from ID conflicts

#### Error Handling

- All scheduling/cancellation calls wrapped in try/catch blocks
- Silent failure handling prevents user-facing errors
- Save/Update/Delete operations succeed regardless of notification status

#### Platform-Specific Behavior

- **Android**: Full alarm-style notifications with insistent alerts
- **iOS/macOS**: Apple restrictions require follow-up notifications
  - Schedules 10 follow-up notifications (1 per minute)
  - Each includes "Mark Done" action button

#### Testing Support

- `NotificationService.computeScheduleTimes(reminder, now)` method
- Returns scheduled times without touching platform plugins
- Enables comprehensive unit testing

---

## 🧪 Testing

Run unit tests:

```bash
flutter test
```

Test files included:

- `test/notification_logic_test.dart` - Notification scheduling logic
- `test/remindertime_scroll_test.dart` - Reminder time picker functionality
- `test/widget_test.dart` - Widget integration tests

---

## 📄 License

This project is developed for portfolio and educational purposes.

---

## 👤 Developer

**Jerwin Agustin**

- GitHub: [@jerwinagustin](https://github.com/jerwinagustin)
- Repository: [PersonalApplication](https://github.com/jerwinagustin/PersonalApplication)
- Gmail: [Work Email](jerwinagustin200@gmail.com)

---

## 📧 Contact & Support

For questions, feedback, or collaboration inquiries regarding LogLife, please reach out through GitHub issues or contact the developer directly.

---

**Built with ❤️ using Flutter & Firebase**
