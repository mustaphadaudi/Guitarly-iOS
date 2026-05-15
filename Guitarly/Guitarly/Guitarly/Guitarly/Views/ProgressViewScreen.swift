import SwiftUI
import SwiftData

struct ProgressViewScreen: View {
    @Query(sort: \Habit.startDate, order: .reverse) private var habits: [Habit]
    @AppStorage("debugDayOffset") private var debugDayOffset = 0

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                Group {
                    if habits.isEmpty {
                        ContentUnavailableView(
                            "No Progress Yet",
                            systemImage: "chart.bar",
                            description: Text("Create and complete habits to see weekly progress.")
                        )
                    } else {
                        List {
                            Section("Testing") {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Simulated date: \(TimeProvider.now.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    HStack {
                                        Button("New Day") {
                                            debugDayOffset += 1
                                            TimeProvider.advanceOneDay()
                                        }
                                        .buttonStyle(.borderedProminent)

                                        Button("Reset") {
                                            debugDayOffset = 0
                                            TimeProvider.resetToToday()
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                }
                                .appCard(border: Theme.accentBlue.opacity(0.25))
                                .listRowBackground(Color.clear)
                            }
                            Section {
                                WeeklyOverviewCard(habits: habits)
                                    .appCard(border: Theme.accentPurple.opacity(0.25))
                                    .listRowBackground(Color.clear)
                            }

                            Section("Habit Progress") {
                                ForEach(habits) { habit in
                                    HabitProgressRow(habit: habit)
                                        .appCard()
                                        .listRowBackground(Color.clear)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                    }
                }
                .navigationTitle("Progress")
            }
        }
    }
}

struct WeeklyOverviewCard: View {
    let habits: [Habit]

    private var totalCompletedThisWeek: Int {
        habits.reduce(0) { $0 + $1.completedCountThisWeek() }
    }

    private var totalTargetsThisWeek: Int {
        habits.reduce(0) { $0 + $1.targetPerWeek }
    }

    private var overallProgress: Double {
        guard totalTargetsThisWeek > 0 else { return 0 }
        return min(Double(totalCompletedThisWeek) / Double(totalTargetsThisWeek), 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("This Week")
                    .font(.headline)

                Spacer()

                Text("\(totalCompletedThisWeek)/\(totalTargetsThisWeek)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: overallProgress)
                .tint(Theme.accentPurple)

            Text("\(totalCompletedThisWeek) of \(totalTargetsThisWeek) target completions")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

struct HabitProgressRow: View {
    let habit: Habit

    private var completed: Int { habit.completedCountThisWeek() }
    private var target: Int { max(habit.targetPerWeek, 1) }

    private var progress: Double {
        min(Double(completed) / Double(target), 1.0)
    }

    private var progressPercent: Int {
        Int((progress * 100).rounded())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(habit.name)
                        .font(.headline)

                    CategoryBadge(text: habit.category)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(completed)/\(target)")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("\(progressPercent)%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            ProgressView(value: progress)
                .tint(Theme.accentPurple)

            HStack {
                Text("🔥 Streak: \(habit.currentStreak())")
                    .font(.caption)
                    .foregroundStyle(.orange)

                Spacer()

                if habit.isCompletedToday() {
                    Text("Completed today")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else {
                    Text("Not completed today")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
               /* // DEBUGs fills completed logs to test progress bars OLD 
                Button("Debug: Fill this week") {
                    _ = habit.debugFillCurrentWeekUpToYesterday()
                }
                .font(.caption2)
                .foregroundStyle(Theme.accentBlue)
                .padding(.top, 4) */
            }
        }
    }
}

#Preview {
    ProgressViewScreen()
}
