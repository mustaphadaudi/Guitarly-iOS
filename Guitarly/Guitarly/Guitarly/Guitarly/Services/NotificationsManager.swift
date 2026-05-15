import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    func scheduleDailyPracticeReminder(hour: Int = 19, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()

        // Remove old reminder before adding a new one
        center.removePendingNotificationRequests(withIdentifiers: ["daily_practice_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "Guitarly Practice Reminder 🎸"
        content.body = "Time for your guitar practice session. Keep your streak alive!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "daily_practice_reminder",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("Failed to schedule reminder: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled for \(hour):\(String(format: "%02d", minute))")
            }
        }
    }

    func cancelDailyPracticeReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_practice_reminder"])
        print("Daily reminder cancelled")
    }
}
