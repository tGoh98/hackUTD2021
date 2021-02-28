//
//  FoundMoment.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/28/21.
//

import SwiftUI

struct FoundMoment: View {
    var imageSource: String
    var body: some View {
        VStack {
            HStack {
                Text("Nice! You found a moment!")
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.top)
                Spacer()
            }
            Image(systemName: "person.fill")
                .data(url: URL(string: imageSource)!)
                .scaledToFit()
                .padding()
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
        .shadow(radius: 1)
        .padding()
    }
}

struct FoundMoment_Previews: PreviewProvider {
    static var previews: some View {
        FoundMoment(imageSource: "https://firebasestorage.googleapis.com/v0/b/hackutd21.appspot.com/o/images%2FEA2333B8-3DBE-4986-8B6F-290FFDD5B3AB?alt=media&token=b192c495-baca-471e-873d-b7a6e3fefda1")
    }
}
