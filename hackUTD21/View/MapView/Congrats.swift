//
//  Congrats.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/28/21.
//

import SwiftUI
import ConfettiSwiftUI
import FirebaseStorage

struct Congrats: View {
    @EnvironmentObject var modelData: ModelData
    @State var counter: Int = 0
    @State var seeMoments: Bool = false
    
    
    var body: some View {
        ZStack {
            if (!seeMoments) {
                VStack {
                    Text("You've finished!\n")
                    Text("\(modelData.createMomentCount) moments")
                        .foregroundColor(Color.init(hex: "FE5722"))
                    Text("on this path really stood out to you")
                    Button(action: {
                        counter += 1
                        populateImgs(modelData: modelData)
                        DispatchQueue.global().asyncAfter(deadline: .now() +  .milliseconds(1500)) {
                            self.seeMoments.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color.init(hex: "FE5722"))
                    }
                    .padding()
                }
                .font(.title2)
            } else {
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                        HStack {
                            Spacer()
                            Text("Your moments")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.trailing)
                            Spacer()
                            Button(action: { modelData.pageNum = 0 }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.init(hex: "FE5722"))
                            }.padding(.trailing)
                        }
                    }
                    ScrollView {
                        ForEach(modelData.uploadURLs, id: \.self) { moURL in
                            Image(systemName: "person.fill")
                                .data(url: URL(string: moURL.absoluteString)!)
                                .scaledToFit()
                                .padding()
                        }
                    }
                }
                
            }
            
            ConfettiCannon(counter: $counter)
        }
    }
    
    func populateImgs(modelData: ModelData) {
        print(modelData.uploadURLs)
    }
}

struct Congrats_Previews: PreviewProvider {
    static var previews: some View {
        Congrats()
            .environmentObject(ModelData())
    }
}


extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}


