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
    var distanceTraveled: Double
    var timeElapsed: Double
    var name: String
    var description: String
    
    init(id: UUID = UUID(), visibility: Visibility, moments: Array<UUID> = [UUID](), creator: UUID, distanceTraveled: Double, timeElapsed: Double, name: String, description: String) {
        self.id = id
        self.visibility = visibility
        self.moments = moments
        self.creator = creator
        self.distanceTraveled = distanceTraveled
        self.timeElapsed = timeElapsed
        self.name = name
        self.description = description
    }
}
