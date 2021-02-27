//
//  Group.swift
//  hackUTD21
//
//

import Foundation

class Group: Identifiable {
    var id: UUID
    var name: String
    var users: Array<UUID>
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
        self.users = [UUID]()
    }
}
