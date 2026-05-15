import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self.startOfDay
    }
}

enum DateHelper {
    static func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        Calendar.current.isDate(lhs, inSameDayAs: rhs)
    }

    static func daysBetween(_ from: Date, _ to: Date) -> Int {
        let calendar = Calendar.current
        let fromDay = calendar.startOfDay(for: from)
        let toDay = calendar.startOfDay(for: to)
        return calendar.dateComponents([.day], from: fromDay, to: toDay).day ?? 0
    }

    static func thisWeekDates() -> [Date] {
        let calendar = Calendar.current
        let start = Date().startOfWeek
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }
}
