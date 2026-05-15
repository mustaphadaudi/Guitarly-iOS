import Foundation
import SwiftData

@Model
final class HabitLog {
    var id: UUID
    var date: Date
    var isCompleted: Bool

    var habit: Habit?

    init(date: Date = Date(), isCompleted: Bool = true, habit: Habit? = nil) {
        self.id = UUID()
        self.date = date
        self.isCompleted = isCompleted
        self.habit = habit
    }
}
