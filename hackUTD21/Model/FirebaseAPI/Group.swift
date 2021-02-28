//
//  Group.swift
//  hackUTD21
//
//

import Foundation

class Group: Identifiable, Codable {
    var id: UUID
    var name: String
    var users: Array<UUID>
    
    init(id: UUID = UUID(), name: String, groups: Array<UUID> = [UUID]()) {
        self.id = id
        self.name = name
        self.users = groups
    }
}
