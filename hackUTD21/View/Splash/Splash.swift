//
//  Splash.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/28/21.
//

import SwiftUI

struct Splash: View {
    var body: some View {
        VStack {
            HStack {
                Text("PathWays")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.init(hex: "FE5722"))
            }
            .padding(.top, 120)
            AnimatedImageView(fileName: "splash")
                .padding(.top, 150)
                .padding(.bottom, 250)
        }
        .background(Color.init(hex: "f9f9f9"))
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
