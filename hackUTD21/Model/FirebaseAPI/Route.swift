//
//  Route.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation


class Route: Identifiable {
    var id: UUID
    var visibility: Visibility
    var moments: Array<Moment>
    var creator: User
    
    init(id: UUID = UUID(), visibility: Visibility) {
        self.id = id
        self.visibility = visibility
        self.moments = [Moment]()
        self.creator = User(name: "TODO") // TODO: get this dynamically
    }
}
