import Foundation
import SwiftUI

enum TimeProvider {
    // Stored in UserDefaults = persists 
    static let offsetKey = "debugDayOffset"

    static var dayOffset: Int {
        UserDefaults.standard.integer(forKey: offsetKey)
    }

    static var now: Date {
        Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
    }

    static func setDayOffset(_ value: Int) {
        UserDefaults.standard.set(value, forKey: offsetKey)
    }

    static func advanceOneDay() {
        setDayOffset(dayOffset + 1)
    }

    static func resetToToday() {
        setDayOffset(0)
    }
}
