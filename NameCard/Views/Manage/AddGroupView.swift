import SwiftUI
import SwiftData

struct AddGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var name: String = ""
    @State private var hue: String = "blue"

    private let hues: [String] = ["red","orange","yellow","green","teal","blue","indigo","purple","pink","gray"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Group") {
                    TextField("Group name", text: $name)
                }
                Section("Color") {
                    HuePalette(hues: hues, selected: $hue)
                        .padding(.vertical, 6)
                }
            }
            .navigationTitle("New Group")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let g = ContactCategory(id: UUID(),
                                                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                                hue: hue)
                        context.insert(g)
                        try? context.save()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

private struct HuePalette: View {
    let hues: [String]
    @Binding var selected: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(hues, id: \.self) { h in
                    HueSwatch(color: colorForHue(h), selected: selected == h)
                        .onTapGesture { selected = h }
                }
            }
        }
    }
}

private struct HueSwatch: View {
    let color: Color
    let selected: Bool

    var body: some View {
        // 拆成小步驟，避免 overlay 裡的運算過重
        let ring = Circle().stroke(selected ? Color.primary.opacity(0.6) : .clear, lineWidth: 2)
        return Circle()
            .fill(color)
            .frame(width: 28, height: 28)
            .overlay(ring)
    }
}

/// 共用色票：讓 AddContactView / PeopleListView 也能用
func colorForHue(_ hue: String) -> Color {
    switch hue {
    case "red": return .red
    case "orange": return .orange
    case "yellow": return .yellow
    case "green": return .green
    case "teal": return .teal
    case "blue": return .blue
    case "indigo": return .indigo
    case "purple": return .purple
    case "pink": return .pink
    default: return .gray
    }
}
