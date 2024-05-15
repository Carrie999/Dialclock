//
//  BuyButtonSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/26.
//

import SwiftUI

struct BuyButtonSwiftUIView: View {
    @AppStorage("isPurchased") var isPurchased: Bool = false
    
    var body: some View {
        if isPurchased {
            
        } else {
            NavigationLink(destination: ProSwiftUIView()) {
                VStack {
                    Image(systemName: "lock.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:200, height: 200)
                        .foregroundColor(Color.black.opacity(0.9))
                        .padding()
                        .opacity(1)
                        .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .frame(width:200, height: 200)
                .background(Color.clear)
                
                .cornerRadius(200)
                .opacity(0.85)
            }
        }
    }
}

#Preview {
    BuyButtonSwiftUIView()
}
