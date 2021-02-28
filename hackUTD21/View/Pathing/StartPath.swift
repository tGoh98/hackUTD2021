//
//  StartPath.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import SwiftUI

struct StartPath: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                HStack {
                    Button(action: { modelData.pageNum = 0 }) {
                        Image(systemName: "chevron.left")
                    }.padding(.leading)
                    Spacer()
                    Text("Start your path")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.trailing)
                    Spacer()
                }
                
            }
            
            MapView()
        }
    }
}

struct StartPath_Previews: PreviewProvider {
    static var previews: some View {
        StartPath()
            .environmentObject(ModelData())
    }
}
