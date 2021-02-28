//
//  Congrats.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/28/21.
//

import SwiftUI
import ConfettiSwiftUI

struct Congrats: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack {
            Text("You've finished!\n")
            Text("12 moments")
                .foregroundColor(Color.init(hex: "FE5722"))
            Text("on this path really stood out to you")
        }
        .font(.title2)
    }
}

struct Congrats_Previews: PreviewProvider {
    static var previews: some View {
        Congrats()
            .environmentObject(ModelData())
    }
}
