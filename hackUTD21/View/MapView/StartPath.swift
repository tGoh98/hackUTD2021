//
//  StartPath.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import SwiftUI

struct StartPath: View {
    @EnvironmentObject var modelData: ModelData
    @State private var started: Bool = true
    
    var body: some View {
        VStack {
            if (!started) {
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
            }
            
            ZStack {
                MapView()
                
                VStack {
                    Spacer()
                    if (!started) {
                        Button (action: { self.started.toggle() })
                        {
                            Text("Let's go")
                                .fontWeight(.semibold)
                                .font(.title3)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .foregroundColor(.white)
                        .background(Color.init(hex: "FF7800"))
                        .cornerRadius(40)
                        .padding(.horizontal, 110)
                        .padding(.bottom, 60)
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                            VStack {
                                HStack {
                                    VStack {
                                        Text("Distance")
                                        Text("0.00")
                                            .font(.title)
                                    }
                                    .padding()
                                    Rectangle()
                                        .fill(Color.init(hex: "C4C4C4"))
                                        .frame(width: 1, height: 50)
                                    VStack {
                                        Text("Time")
                                        Text("0:00")
                                            .font(.title)
                                    }
                                    .padding()
                                    Rectangle()
                                        .fill(Color.init(hex: "C4C4C4"))
                                        .frame(width: 1, height: 50)
                                    VStack {
                                        Text("Moments")
                                        Text("0")
                                            .font(.title)
                                    }
                                    .padding()
                                }
                                
                                Button (action: { self.started.toggle() })
                                {
                                    Text("Finish")
                                        .fontWeight(.semibold)
                                        .font(.title3)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(.vertical, 7)
                                .foregroundColor(.white)
                                .background(Color.init(hex: "FF7800"))
                                .cornerRadius(40)
                                .padding(.horizontal, 20)
                                .padding(.bottom)
                            }
                            
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct StartPath_Previews: PreviewProvider {
    static var previews: some View {
        StartPath()
            .environmentObject(ModelData())
    }
}
