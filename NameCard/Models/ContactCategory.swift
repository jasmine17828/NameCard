//
//  ContactCategory.swift
//  NameCard
//
//  Created by fcuiecs on 2025/9/16.
//

import SwiftData
import Foundation

@Model
class ContactCategory {
    var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
