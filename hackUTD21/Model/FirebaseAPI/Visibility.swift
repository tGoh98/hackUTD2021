//
//  File.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation

class Visibility: Identifiable, Codable {
    var type: Int // 0: private, 1: group, 2: everyone
    var groups: Array<UUID>
    
    init(type: Int, groups: Array<UUID> = [UUID]()) {
        self.type = type
        self.groups = groups
//        if (type == 2) {
//            // TODO: add everyone const for group
//
//        }
    }
}
