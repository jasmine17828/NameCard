import SwiftUI
import SwiftData

struct ManageView: View {
    @Environment(\.modelContext) private var context

    @Query(sort: \ContactCategory.name)
    private var categories: [ContactCategory]

    @Query(sort: \StoredContact.name)
    private var contacts: [StoredContact]

    @State private var showAddGroup = false
    @State private var showAddContact = false

    var body: some View {
        NavigationStack {
            List {
                Section("Groups") {
                    if categories.isEmpty {
                        Text("No groups yet").foregroundStyle(.secondary)
                    } else {
                        ForEach(categories) { group in
                            HStack {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(colorForHue(group.hue))
                                Text(group.name)
                                Spacer()
                                Text("\(group.contacts.count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { categories[$0] }.forEach(context.delete)
                            try? context.save()
                        }
                    }
                }

                Section("Contacts") {
                    if contacts.isEmpty {
                        Text("No contacts yet").foregroundStyle(.secondary)
                    } else {
                        ForEach(contacts) { c in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(c.displayName).font(.headline)
                                HStack(spacing: 8) {
                                    if !c.title.isEmpty {
                                        Text(c.title).font(.subheadline).foregroundStyle(.secondary)
                                    }
                                    if !c.email.isEmpty {
                                        Text("· \(c.email)").font(.caption).foregroundStyle(.secondary)
                                    }
                                }
                                if let grp = c.category {
                                    Text(grp.name).font(.caption2).foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { contacts[$0] }.forEach(context.delete)
                            try? context.save()
                        }
                    }
                }
            }
            .navigationTitle("Manage")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button { showAddGroup = true } label: {
                        Label("Add Group", systemImage: "folder.badge.plus")
                    }
                    Button { showAddContact = true } label: {
                        Label("Add Contact", systemImage: "person.crop.circle.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $showAddGroup) { AddGroupView() }
            .sheet(isPresented: $showAddContact) { AddContactView() }
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
