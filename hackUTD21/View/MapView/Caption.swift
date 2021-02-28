//
//  caption.swift
//  hackUTD21
//
//  Created by Seung Hun Jang on 2/28/21.
//

import SwiftUI

struct Caption: View {
    @State private var caption: String = ""
    
    var body: some View {
        
        TextField("Enter Caption", text: $caption)
        Text("Hello, \(caption)")
        
    }
}

struct Caption_Previews: PreviewProvider {
    static var previews: some View {
        Caption()
    }
}
