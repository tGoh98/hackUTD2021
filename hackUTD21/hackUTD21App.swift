//
//  hackUTD21App.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import SwiftUI
import Firebase

@main
struct hackUTD21App: App {
    
    init() {
        FirebaseApp.configure()
        
        
        let io:RequestIO = RequestIO(dbref: Database.database().reference())
//        let r = Route(id: UUID())
//        io.createRoute(route: r)
//        io.createUser(name: "Seung")
//        io.createUser(name: "Tim")
        
//        io.getUsers()
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
