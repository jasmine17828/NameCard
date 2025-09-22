import SwiftData
import Foundation

@Model
class ContactCategory {
    var id: UUID
    var name: String
    var hue: String

    @Relationship(inverse: \StoredContact.category)
    var contacts: [StoredContact] = []

    init(id: UUID, name: String, hue: String = "blue") {
        self.id = id
        self.name = name
        self.hue = hue
    }
}
