//
//  User.swift
//  hackUTD21
//
//  Created by Seung Hun Jang on 2/27/21.
//

import Foundation


class User: Identifiable {
    var id: UUID
    var name: String
    var groups: Array<UUID>
    var routes: Array<UUID>
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.groups = [UUID]()
        self.routes = [UUID]()
    }
}
