import SwiftUI
import SwiftData

struct HabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.startDate, order: .reverse) private var habits: [Habit]

    @State private var showingAddHabit = false
    @State private var selectedHabitForEdit: Habit?

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                Group {
                    if habits.isEmpty {
                        ContentUnavailableView(
                            "No Habits Yet",
                            systemImage: "music.note",
                            description: Text("Tap + to create your first guitar practice habit.")
                        )
                    } else {
                        List {
                            Section {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Your Practice Habits")
                                        .font(.headline)

                                    Text("Create, edit, and track habits daily.")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .appCard(border: Theme.accentPurple.opacity(0.25))
                                .listRowBackground(Color.clear)
                            }

                            Section("All Habits") {
                                ForEach(habits) { habit in
                                    Button {
                                        selectedHabitForEdit = habit
                                    } label: {
                                        HabitCardRow(habit: habit)
                                    }
                                    .buttonStyle(.plain)
                                    .appCard()
                                    .listRowBackground(Color.clear)
                                }
                                .onDelete(perform: deleteHabits)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                    }
                }
                .navigationTitle("Habits")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddHabit = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddHabit) {
                    AddHabitView()
                }
                .sheet(item: $selectedHabitForEdit) { habit in
                    EditHabitView(habit: habit)
                }
            }
        }
    }

    private func deleteHabits(at offsets: IndexSet) {
        for index in offsets {
            let habit = habits[index]
            modelContext.delete(habit)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete habit: \(error.localizedDescription)")
        }
    }
}

struct HabitCardRow: View {
    let habit: Habit

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "guitars")
                .font(.title3)
                .foregroundStyle(Theme.accentPurple)

            VStack(alignment: .leading, spacing: 6) {
                Text(habit.name)
                    .font(.headline)

                HStack(spacing: 8) {
                    CategoryBadge(text: habit.category)

                    Text("\(habit.targetPerWeek)x / week")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                if habit.isCompletedToday() {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "circle")
                        .foregroundStyle(.secondary)
                }

                Text("🔥 \(habit.currentStreak())")
                    .font(.caption2)
                    .foregroundStyle(.orange)
            }
        }
    }
}

#Preview {
    HabitsView()
}
