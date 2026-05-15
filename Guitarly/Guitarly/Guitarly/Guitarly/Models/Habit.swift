import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var category: String
    var startDate: Date
    var targetPerWeek: Int
    var reminderEnabled: Bool
    var isArchived: Bool

    @Relationship(deleteRule: .cascade, inverse: \HabitLog.habit)
    var logs: [HabitLog]

    init(
        name: String,
        category: String,
        startDate: Date = Date(),
        targetPerWeek: Int = 7,
        reminderEnabled: Bool = true,
        isArchived: Bool = false
    ) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.startDate = startDate
        self.targetPerWeek = targetPerWeek
        self.reminderEnabled = reminderEnabled
        self.isArchived = isArchived
        self.logs = []
    }

    func logForToday() -> HabitLog? {
        logs.first(where: { DateHelper.isSameDay($0.date, TimeProvider.now) })
    }

    func isCompletedToday() -> Bool {
        logForToday()?.isCompleted == true
    }

    func completedCountThisWeek() -> Int {
        let calendar = Calendar.current
        let startOfWeek = TimeProvider.now.startOfWeek

        guard let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
            return 0
        }

        return logs.filter { log in
            log.isCompleted &&
            log.date >= startOfWeek &&
            log.date < endOfWeek
        }.count
    }

    func currentStreak() -> Int {
        let calendar = Calendar.current
        let completedDays = Set(
            logs
                .filter { $0.isCompleted }
                .map { calendar.startOfDay(for: $0.date) }
        )

        var streak = 0
        var day = calendar.startOfDay(for: TimeProvider.now)

        guard completedDays.contains(day) else { return 0 }

        while completedDays.contains(day) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previousDay
        }

        return streak
    }
    
    
    
    /*func logForToday() -> HabitLog? { OLd version chnaged the date to ue timeprovider
        logs.first(where: { DateHelper.isSameDay($0.date, Date()) })
    }

    func isCompletedToday() -> Bool {
        logForToday()?.isCompleted == true
    }

    func completedCountThisWeek() -> Int {
        let calendar = Calendar.current
        let startOfWeek = Date().startOfWeek

        guard let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
            return 0
        }

        return logs.filter { log in
            log.isCompleted &&
            log.date >= startOfWeek &&
            log.date < endOfWeek
        }.count
    }

    func currentStreak() -> Int {
        let calendar = Calendar.current
        let completedDays = Set(
            logs
                .filter { $0.isCompleted }
                .map { calendar.startOfDay(for: $0.date) }
        )

        var streak = 0
        var day = calendar.startOfDay(for: Date())

        // streak: if today is not completed, streak is 0 like quranly maybe a last chance if its 2 in a row then you lose streak
        guard completedDays.contains(day) else { return 0 }

        while completedDays.contains(day) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: day) else {
                break
            }
            day = previousDay
        }

        return streak */
    }
  /*  // DEBUG : fill completed logs for the week didnt work :(
    func debugFillCurrentWeekUpToYesterday() -> Int {
        let calendar = Calendar.current
        let start = Date().startOfWeek
        let today = calendar.startOfDay(for: Date())

        var created = 0
        var day = start

        while day < today {
            let exists = logs.contains(where: { calendar.isDate($0.date, inSameDayAs: day) })
            if !exists {
                let log = HabitLog(date: day, isCompleted: true, habit: self)
                logs.append(log)
                created += 1
            }

            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = nextDay
        }

        return created
    } */
    

