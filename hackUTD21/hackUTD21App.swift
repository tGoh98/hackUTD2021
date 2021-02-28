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
    @StateObject private var modelData = ModelData()
    @State var step: Int = 0
    let splashTimer = Timer.publish(every: 3, on: .current, in: .common).autoconnect()
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            if (step == 0) {
                Splash()
            } else {
                ContentView()
                    .environmentObject(modelData)
            }
            Text("")
                .frame(maxWidth: 0, maxHeight:0)
                .onReceive(splashTimer) { _ in
                    if (self.step == 0) {
                        self.step += 1
                    }
                    if (self.step >= 2) {
                        self.splashTimer.upstream.connect().cancel()
                    }
                }
            
        }
    }
}
