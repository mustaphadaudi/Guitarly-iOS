//
//  GuitarlyApp.swift
//  Guitarly
//
//  Created by Daudi, Mustapha on 18/02/2026.
//

import SwiftUI
import SwiftData

@main
struct GuitarlyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(Theme.accentPurple)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [Habit.self, HabitLog.self])
    }
}
