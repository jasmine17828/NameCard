import SwiftUI
import SwiftData

struct PeopleListView: View {
    let people = Person.sampleData

    @Query(sort: \ContactCategory.name) private var categories: [ContactCategory]

    @State private var showAddGroup = false
    @State private var showAddContact = false

    var teachersSorted: [Person] {
        people.filter { $0.type == .teacher }.sorted { $0.name < $1.name }
    }

    var studentsSorted: [Person] {
        people.filter { $0.type == .student }.sorted { $0.name < $1.name }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Teachers") {
                    ForEach(teachersSorted) { person in
                        NavigationLink(destination: PersonDetailView(person: person)) {
                            PersonRowView(person: person)
                        }
                    }
                }

                Section("Students") {
                    ForEach(studentsSorted) { person in
                        NavigationLink(destination: PersonDetailView(person: person)) {
                            PersonRowView(person: person)
                        }
                    }
                }

                Section("Contacts") {
                    if categories.isEmpty {
                        Text("No groups yet").foregroundStyle(.secondary)
                    } else {
                        ForEach(categories) { cat in
                            NavigationLink {
                                CategoryDetailView(category: cat)
                            } label: {
                                HStack {
                                    Circle().frame(width: 10, height: 10).foregroundStyle(colorForHue(cat.hue))
                                    Text(cat.name)
                                    Spacer()
                                    Text("\(cat.contacts.count) \(cat.contacts.count == 1 ? "contact" : "contacts")")
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Directory")
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

struct PersonRowView: View {
    let person: Person

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(person.name).font(.headline)
                Text(person.type.rawValue.dropLast()).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            if person.contact != nil {
                Image(systemName: "person.crop.rectangle").foregroundStyle(.blue)
            }
        }
        .padding(.vertical, 2)
    }
}

struct PersonDetailView: View {
    let person: Person

    var body: some View {
        Group {
            if let contact = person.contact {
                if person.name == "Jasmine" {
                    ChibiFlipCardView {
                        KawaiiNameCardFrontView(contact: contact)
                    } back: {
                        KawaiiNameCardBackView(vcard: contact.toVCard())
                    }
                    .padding()
                } else {
                    HarryView(contact: contact)
                }
            } else {
                VStack {
                    Image(systemName: "person.fill").font(.system(size: 80)).foregroundStyle(.gray)
                    Text(person.name).font(.largeTitle).padding()
                    Text("No name card available").font(.body).foregroundStyle(.secondary)
                }
                .padding()
            }
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PeopleListView()
}
