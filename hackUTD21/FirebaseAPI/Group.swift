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
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.users = [UUID]()
    }
}
