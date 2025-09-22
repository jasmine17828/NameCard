import SwiftData
import Foundation

@Model
class StoredContact {
    var id: UUID
    var name: String

    var firstName: String?
    var lastName: String?
    var title: String
    var department: String?

    var organization: String?
    var address: String?

    var email: String
    var phone: String?
    var website: String?

    var category: ContactCategory?

    init(
        id: UUID,
        name: String,
        title: String,
        email: String,
        firstName: String? = nil,
        lastName: String? = nil,
        department: String? = nil,
        organization: String? = nil,
        address: String? = nil,
        phone: String? = nil,
        website: String? = nil,
        category: ContactCategory? = nil
    ) {
        self.id = id
        self.name = name
        self.title = title
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.department = department
        self.organization = organization
        self.address = address
        self.phone = phone
        self.website = website
        self.category = category
    }

    var displayName: String {
        if let f = firstName, !f.isEmpty, let l = lastName, !l.isEmpty {
            return "\(f) \(l)"
        }
        return name
    }
}
