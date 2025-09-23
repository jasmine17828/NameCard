import SwiftUI
import SwiftData

struct ManageView: View {
    @Environment(\.modelContext) private var context

    @Query(sort: \ContactCategory.name)
    private var categories: [ContactCategory]

    @Query(sort: \StoredContact.name)
    private var contacts: [StoredContact]

    // 直接用 SwiftData 查出未分組聯絡人
    @Query(
        filter: #Predicate<StoredContact> { $0.category == nil },
        sort: \StoredContact.name
    )
    private var ungrouped: [StoredContact]

    @State private var showAddGroup = false
    @State private var showAddContact = false

    var body: some View {
        NavigationStack {
            List {
                Section("Groups") {
                    // 未分組入口：永遠顯示，沒有資料時顯示 0 並淡化/不可點
                    NavigationLink {
                        ContactListView(contacts: ungrouped, title: "未分組")
                    } label: {
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(Color.gray)
                            Text("未分組")
                            Spacer()
                            Text("\(ungrouped.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .disabled(ungrouped.isEmpty)
                    .opacity(ungrouped.isEmpty ? 0.6 : 1.0)

                    if categories.isEmpty && ungrouped.isEmpty {
                        Text("No groups yet").foregroundStyle(.secondary)
                    }

                    // 既有群組
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
                                } else {
                                    Text("未分組").font(.caption2).foregroundStyle(.secondary)
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

// 簡單的聯絡人列表頁（用於「未分組」）
private struct ContactListView: View {
    let contacts: [StoredContact]
    let title: String

    var body: some View {
        List {
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
                    } else {
                        Text("未分組").font(.caption2).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}
