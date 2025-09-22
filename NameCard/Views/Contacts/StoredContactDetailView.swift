import SwiftUI

struct StoredContactDetailView: View {
    let contact: StoredContact

    var body: some View {
        Form {
            Section("Personal Information") {
                LabeledContent("First Name", value: contact.firstName ?? "")
                LabeledContent("Last Name", value: contact.lastName ?? "")
                LabeledContent("Title", value: contact.title)
                LabeledContent("Department", value: contact.department ?? "")
            }
            Section("Organization") {
                LabeledContent("Organization", value: contact.organization ?? "")
                LabeledContent("Address", value: contact.address ?? "")
            }
            Section("Contact") {
                LabeledContent("Email", value: contact.email)
                LabeledContent("Phone", value: contact.phone ?? "")
                LabeledContent("Website", value: contact.website ?? "")
            }
            if let cat = contact.category {
                Section("Category") {
                    Text(cat.name)
                }
            }
        }
        .navigationTitle(contact.displayName)
    }
}
