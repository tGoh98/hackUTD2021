//
//  FeedCard.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import SwiftUI

struct FeedCard: View {
    var body: some View {
        VStack {
            HStack {
                Text("Name")
                Spacer()
            }
            Divider()
            Image("mapHolder")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .padding(10)
        .background(Color.init(hex: "007AFF").opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 8.0)))
    }
}

struct FeedCard_Previews: PreviewProvider {
    static var previews: some View {
        FeedCard()
    }
}
