//
//  ContentView.swift
//  Guitarly
//
//  Created by Daudi, Mustapha on 18/02/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "sun.max")
                }

            HabitsView()
                .tabItem {
                    Label("Habits", systemImage: "guitars")
                }

            ProgressViewScreen()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView()
}
