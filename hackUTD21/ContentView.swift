//
//  ContentView.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        ZStack {
            switch (modelData.pageNum) {
            case 0:
                Feed()
            case 1:
                StartPath()
            case 2:
                Congrats()
            default:
                Text("pageNum not found!")
            }

            if (modelData.pageNum == 0) {
                VStack() {
                    Spacer()
                    HStack() {
                        Spacer()
                        Button(action: {
                            modelData.pageNum = 1
                        }, label: {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(.largeTitle))
                                .frame(width: 55, height: 50)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 7)
                                .padding(5)
                        })
                        .background(Color.init(hex: "FE5722"))
                        .cornerRadius(38.5)
                        .padding()
                        .padding(.trailing)
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
