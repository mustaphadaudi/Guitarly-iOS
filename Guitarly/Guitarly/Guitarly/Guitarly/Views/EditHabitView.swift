import SwiftUI
import SwiftData

struct EditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let habit: Habit

    @State private var name: String
    @State private var selectedCategory: String
    @State private var targetPerWeek: Int
    @State private var reminderEnabled: Bool

    let categories = [
        "Technique",
        "Songs",
        "Scales",
        "Chords",
        "Ear Training",
        "Theory",
        "Improvisation",
        "Creativity"
    ]

    init(habit: Habit) {
        self.habit = habit
        _name = State(initialValue: habit.name)
        _selectedCategory = State(initialValue: habit.category)
        _targetPerWeek = State(initialValue: habit.targetPerWeek)
        _reminderEnabled = State(initialValue: habit.reminderEnabled)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Habit Details") {
                    TextField("Habit name", text: $name)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }

                    Stepper(value: $targetPerWeek, in: 1...7) {
                        Text("Target: \(targetPerWeek) time\(targetPerWeek == 1 ? "" : "s") per week")
                    }

                    Toggle("Enable reminder", isOn: $reminderEnabled)
                }

                Section {
                    Text("Started: \(habit.startDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveChanges() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        habit.name = trimmedName
        habit.category = selectedCategory
        habit.targetPerWeek = targetPerWeek
        habit.reminderEnabled = reminderEnabled

        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to update habit: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let sampleHabit = Habit(name: "Practice scales", category: "Scales", targetPerWeek: 5)
    return EditHabitView(habit: sampleHabit)
}
