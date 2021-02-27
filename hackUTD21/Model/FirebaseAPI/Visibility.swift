//
//  File.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation

class Visibility: Identifiable {
    var type: VisibilityType
    var groups: Array<Group>
    
    init(type: VisibilityType, groups: Array<Group>) {
        self.type = type
        self.groups = groups
        if (type == VisibilityType.Everyone) {
            // TODO: add everyone const for group
        }
    }
}
