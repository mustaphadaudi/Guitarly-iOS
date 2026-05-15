import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("reminderHour") private var reminderHour = 19
    @AppStorage("reminderMinute") private var reminderMinute = 0

    @State private var notificationStatusText = "Checking..."

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                Form {
                    Section("Practice Reminders") {
                        Toggle("Enable daily reminder", isOn: Binding(
                            get: { notificationsEnabled },
                            set: { newValue in
                                handleReminderToggleChange(newValue)
                            }
                        ))

                        DatePicker(
                            "Reminder time",
                            selection: reminderTimeBinding,
                            displayedComponents: .hourAndMinute
                        )
                        .disabled(!notificationsEnabled)

                        Button("Refresh notification status") {
                            refreshNotificationStatus()
                        }

                        Text("Status: \(notificationStatusText)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Section("About") {
                        Text("Guitarly helps you build consistent guitar practice habits with daily logging, streaks, weekly progress, and reminders.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Settings")
                .onAppear { refreshNotificationStatus() }
            }
        }
    }

    private var reminderTimeBinding: Binding<Date> {
        Binding<Date>(
            get: {
                var components = DateComponents()
                components.hour = reminderHour
                components.minute = reminderMinute
                return Calendar.current.date(from: components) ?? Date()
            },
            set: { newDate in
                let components = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                reminderHour = components.hour ?? 19
                reminderMinute = components.minute ?? 0

                if notificationsEnabled {
                    NotificationManager.shared.scheduleDailyPracticeReminder(
                        hour: reminderHour,
                        minute: reminderMinute
                    )
                }
            }
        )
    }

    private func handleReminderToggleChange(_ enabled: Bool) {
        if enabled {
            NotificationManager.shared.requestPermission { granted in
                if granted {
                    notificationsEnabled = true
                    NotificationManager.shared.scheduleDailyPracticeReminder(
                        hour: reminderHour,
                        minute: reminderMinute
                    )
                    refreshNotificationStatus()
                } else {
                    notificationsEnabled = false
                    refreshNotificationStatus()
                }
            }
        } else {
            notificationsEnabled = false
            NotificationManager.shared.cancelDailyPracticeReminder()
            refreshNotificationStatus()
        }
    }

    private func refreshNotificationStatus() {
        NotificationManager.shared.getAuthorizationStatus { status in
            switch status {
            case .notDetermined:
                notificationStatusText = "Not determined"
            case .denied:
                notificationStatusText = "Denied (enable in Settings app)"
            case .authorized:
                notificationStatusText = "Authorized"
            case .provisional:
                notificationStatusText = "Provisional"
            case .ephemeral:
                notificationStatusText = "Ephemeral"
            @unknown default:
                notificationStatusText = "Unknown"
            }
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
