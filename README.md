# personal_application

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
## Reminder Notifications

This app schedules local notifications for reminders with three key triggers:

- 1 hour before the reminder time
- 30 minutes before the reminder time
- At the exact due time (alarm-style on Android)

### Timezone and Timing
- Time parsing uses `intl` with the format `h:mm a` (e.g., `10:00 PM`).
- Timezone handling uses `timezone` and `flutter_timezone` to set the device’s local zone.
- Scheduling filters out any times in the past; if the due time is already past, an immediate alert is shown.

### Notification IDs
- IDs are derived from the Firestore reminder id, hashed and constrained to a safe 32-bit range.
- Offsets are small (e.g., `+1`, `+2`, `+3`, `+100 + i`) to prevent collisions and native errors.

### Error Handling and Fallbacks
- Scheduling and cancellation calls are wrapped in try/catch to avoid surfacing plugin errors to the user.
- Save/Update/Delete flows succeed even if scheduling/cancellation fails silently.

### iOS/macOS Behavior
- Apple restricts continuous “insistent” alarms; the app schedules follow-up notifications (1/minute for 10 minutes) prompting the user to “Mark Done”.

### Testing Helpers
- `NotificationService.computeScheduleTimes(reminder, now)` returns the list of times that would be scheduled (without touching platform plugins) to enable unit tests.
