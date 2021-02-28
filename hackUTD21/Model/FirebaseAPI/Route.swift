//
//  Route.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation


class Route: Identifiable, Codable {
    var id: UUID
    var visibility: Visibility
    var moments: Array<UUID>
    var creator: UUID
    
    init(id: UUID = UUID(), visibility: Visibility, moments: Array<UUID> = [UUID](), creator: UUID) {
        self.id = id
        self.visibility = visibility
        self.moments = moments
        self.creator = creator
    }
}
