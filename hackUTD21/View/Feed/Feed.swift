//
//  Feed.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import SwiftUI

struct Feed: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(1..<10) { _ in
                        FeedCard()
                    }
                    
                }
                .padding()
            }
            VStack {
                Spacer()
                HStack() {
                    Spacer()
                    Button(action: {
                        modelData.pageNum = 1
                    }, label: {
                        Text("+")
                            .font(.system(.largeTitle))
                            .frame(width: 77, height: 70)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 7)
                    })
                    .background(Color.blue)
                    .cornerRadius(38.5)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                }
            }
        }
    }
}

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        Feed()
    }
}
