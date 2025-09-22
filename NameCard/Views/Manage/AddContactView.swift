import SwiftUI
import SwiftData

struct AddContactView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Query(sort: \ContactCategory.name)
    private var categories: [ContactCategory]

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var title: String = ""
    @State private var department: String = ""
    @State private var organization: String = ""
    @State private var address: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var website: String = ""
    @State private var selectedCategory: ContactCategory? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Title", text: $title)
                    TextField("Department", text: $department)
                }
                Section("Organization") {
                    TextField("Organization", text: $organization)
                    TextField("Address", text: $address)
                }
                Section("Contact") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Website", text: $website)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        Text("None").tag(Optional<ContactCategory>.none)
                        ForEach(categories) { c in
                            HStack {
                                Circle().frame(width: 10, height: 10)
                                    .foregroundStyle(colorForHue(c.hue))
                                Text(c.name)
                            }
                            .tag(Optional<ContactCategory>.some(c))
                        }
                    }
                }
            }
            .navigationTitle("New Contact")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let fullName = [firstName, lastName].map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }.joined(separator: " ")
                        let display = fullName.isEmpty ? (email.isEmpty ? "New Contact" : email) : fullName
                        let c = StoredContact(
                            id: UUID(),
                            name: display,
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                            firstName: firstName, lastName: lastName,
                            department: department,
                            organization: organization,
                            address: address,
                            phone: phone,
                            website: website,
                            category: selectedCategory
                        )
                        context.insert(c)
                        try? context.save()
                        dismiss()
                    }
                    .disabled(
                        email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        && firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        && lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
        }
    }

    private func colorForHue(_ hue: String) -> Color {
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
}
