//
//  User.swift
//  hackUTD21
//
//

import Foundation


class User: Identifiable, Codable {
    var id: UUID
    var name: String
    var groups: Array<UUID>
    var routes: Array<UUID>
    
    init(id: UUID = UUID(), name: String, groups: Array<UUID> = [UUID](), routes: Array<UUID> = [UUID]()) {
        self.id = id
        self.name = name
        self.groups = groups
        self.routes = routes
        
    }
}
