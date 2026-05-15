# Guitarly 🎸  
A Smart Habit & Wellbeing Companion (iOS) focused on building consistent guitar practice habits.

Guitarly allows users to create guitar-practice habits, log daily completion, track streaks, and view weekly progress summaries. The app is designed for short, frequent interactions and stores all data locally on-device.

---

## Features (mapped to coursework spec)

### Core functionality
- Create, view, edit, and delete habits (CRUD)
- Log daily completion for each habit
- View habit completion status for the current day
- Each habit includes:
  - Habit name (required)
  - Category (e.g., Technique, Songs, Scales)
  - Start date (auto-generated)
  - Target frequency (times per week)

### Smart features
- **Group A:** Streak tracking (consecutive days completed, resets correctly after missed days)
- **Group B:** Visual progress indicators (weekly progress bars + completion percentages)

### Mobile feature (device capability)
- Local notifications: daily practice reminders with permission handling and time selection

### Data management
- Local persistence using **SwiftData**
- Data remains consistent across app restarts

---

## Tech Stack
- Swift
- SwiftUI
- SwiftData (local persistence)
- UserNotifications (reminders)

---

## Project Structure (high level)
- `Models/` – SwiftData models (Habit, HabitLog)
- `Views/` – SwiftUI screens (Today, Habits, Progress, Settings)
- `Services/` – Notification manager
- `Utilities/` – Date helpers, theme styling, TimeProvider (testing utility)

---

## Running the project (Xcode)
1. Clone the repository
2. Open `Guitarly.xcodeproj` in Xcode
3. Select an iPhone simulator (e.g., iPhone 16 Pro)
4. Press **Run** (▶)

> Note: Notification pop-ups can be inconsistent in the iOS Simulator, but authorization + scheduling logic is implemented and works reliably on-device.

---

## UI / Design Notes
The UI uses a premium dark theme with card-style surfaces and subtle accent borders, inspired by the visual style of Quranly. Styling is centralized via a theme utility to keep the design consistent across screens.

---

## Testing Notes (weekly progress)
To validate multi-day weekly progress without changing the device clock, the project includes a temporary “testing” control using a TimeProvider day offset (New Day / Reset). This allows simulation of multiple days while preserving persisted logs.

---

## Future Improvements
Guitarly is intentionally designed as a habit-adherence layer that could integrate into learning platforms such as Fender Play, Simply Guitar, or Gibson-style learning apps—adding streaks, weekly targets, and reminders to instructional content.

---

## Author
Mustapha Daudi
