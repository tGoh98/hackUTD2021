//
//  MyMoment.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/28/21.
//

import SwiftUI
import FirebaseStorage

struct MyMoment: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var showMomentDialog: Bool
    @Binding var image: UIImage
    @Binding var momentUUID: UUID
    
    var body: some View {
        VStack {
            //            if (showMomentDialog) {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                HStack {
                    Button(action: {
                        let ref = Storage.storage().reference().child("images/\(momentUUID)")
                        let data = image.jpegData(compressionQuality: 0.1)!
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        
                        let uploadTask = ref.putData(data, metadata: metadata) { (metadata, error) in
                            guard let metadata = metadata else {
                                // Uh-oh, an error occurred!
                                return
                              }
                              // Metadata contains file metadata such as size, content-type.
                              let size = metadata.size
                              // You can also access to download URL after upload.
                              ref.downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                  // Uh-oh, an error occurred!
                                  return
                                }
                                modelData.uploadURLs.append(url!)
                              }
                        }
                        showMomentDialog.toggle()
                    }) {
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
