//
//  MyMoment.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/28/21.
//

import SwiftUI

struct MyMoment: View {
    
    @Binding var showMomentDialog: Bool
    @Binding var image: UIImage
    
    var body: some View {
        VStack {
//            if (showMomentDialog) {
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                    HStack {
                        Button(action: { showMomentDialog.toggle() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color.init(hex: "FE5722"))
                        }.padding(.leading)
                        Spacer()
                        Text("My Moment")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.trailing)
                        Spacer()
                    }
                }
//            }
            Image(uiImage: self.image)
//            Image("asdf")
                .resizable()
//                .scaledToFill()
//                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 400)
//            MapView(started: $started)
//                .ignoresSafeArea()
        }
        .padding(.top, 50)
    }
}

//struct MyMoment_Previews: PreviewProvider {
//    static var previews: some View {
//        MyMoment(showMomentDialog: .constant(true))
//    }
//}
