import SwiftUI
import SwiftData

struct CategoryDetailView: View {
    let category: ContactCategory
    private let catID: UUID

    @Query private var contacts: [StoredContact]

    init(category: ContactCategory) {
        self.category = category
        self.catID = category.id
        _contacts = Query(
            filter: #Predicate<StoredContact> { $0.category?.id == catID },
            // 兩種都可：換你專案的 Swift 版本擇一
            // sort: \StoredContact.name
            sort: [SortDescriptor(\StoredContact.name, order: .forward)]
        )
    }

    var body: some View {
        List {
            ForEach(contacts) { c in
                NavigationLink {
                    StoredContactDetailView(contact: c)
                } label: {
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
                    }
                }
            }
        }
        .navigationTitle(category.name)
    }
}
