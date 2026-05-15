import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var selectedCategory = "Technique"
    @State private var targetPerWeek = 7
    @State private var reminderEnabled = true

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
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveHabit() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else { return }

        let newHabit = Habit(
            name: trimmedName,
            category: selectedCategory,
            targetPerWeek: targetPerWeek,
            reminderEnabled: reminderEnabled
        )

        modelContext.insert(newHabit)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save habit: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddHabitView()
}
