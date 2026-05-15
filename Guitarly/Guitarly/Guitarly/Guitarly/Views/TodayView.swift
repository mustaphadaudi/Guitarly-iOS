import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.startDate, order: .reverse) private var habits: [Habit]

    var completedTodayCount: Int {
        habits.filter { $0.isCompletedToday() }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                Group {
                    if habits.isEmpty {
                        ContentUnavailableView(
                            "No Habits Yet",
                            systemImage: "sun.max",
                            description: Text("Create habits in the Habits tab to start tracking today.")
                        )
                    } else {
                        List {
                            Section {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image("GuitarlyLogo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 28, height: 28)
                                            .opacity(0.95)

                                        Text("Today's Progress")
                                            .font(.headline)
                                    }

                                    ProgressView(
                                        value: Double(completedTodayCount),
                                        total: Double(max(habits.count, 1))
                                    )

                                    Text("\(completedTodayCount) of \(habits.count) completed")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .appCard(border: Theme.accentPurple.opacity(0.25))
                            }

                            Section("Today's Habits") {
                                ForEach(habits) { habit in
                                    TodayHabitRow(
                                        habit: habit,
                                        onToggle: { toggleToday(for: habit) }
                                    )
                                    .appCard()
                                    .listRowBackground(Color.clear)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                    }
                }
                .navigationTitle("Guitarly")
            }
        }
    }
    
    private func toggleToday(for habit: Habit) {
        let today = TimeProvider.now.startOfDay

        if let existingLog = habit.logs.first(where: { DateHelper.isSameDay($0.date, today) }) {
            existingLog.isCompleted.toggle()
            existingLog.date = today
        } else {
            let newLog = HabitLog(date: today, isCompleted: true, habit: habit)
            habit.logs.append(newLog)
            modelContext.insert(newLog)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to toggle today's log: \(error.localizedDescription)")
        }
    }
    
   /* private func toggleToday(for habit: Habit) { old verion uses date not timeprovider
        if let existingLog = habit.logForToday() {
            existingLog.isCompleted.toggle()
            existingLog.date = Date().startOfDay
        } else {
            let newLog = HabitLog(date: Date().startOfDay, isCompleted: true, habit: habit)
            habit.logs.append(newLog)
            modelContext.insert(newLog)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to toggle today's log: \(error.localizedDescription)")
        }
    } */
}

struct TodayHabitRow: View {
    let habit: Habit
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: habit.isCompletedToday() ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(habit.isCompletedToday() ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)

                HStack(spacing: 8) {
                    Text(habit.category)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if habit.isCompletedToday() {
                        Text("Completed today")
                            .font(.caption)
                            .foregroundStyle(.green)
                    } else {
                        Text("Not completed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(habit.completedCountThisWeek())/\(habit.targetPerWeek)")
                    .font(.caption)
                    .fontWeight(.semibold)

                Text("this week")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onToggle()
        }
    }
}

#Preview {
    TodayView()
}
