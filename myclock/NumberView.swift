//
//  NumberView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/23.
//

import Foundation
import SwiftUI

struct NumberView :View{
    var number: Int
    var body: some View{
        Text("\(number)")
            .font(.custom("Bebas Neue", size: 120)).offset(y:10) .padding(.vertical,20)
//            .font(.system(size: 90,weight: .bold,design: .default))
            .foregroundColor(.white)
            .frame(width: 80,height: 100)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
           
        
       
    }
}

extension Date{
    func component(_ component: Calendar.Component)->Int{
        let calendar = Calendar.current
        return calendar.component(component, from:self)
    }
}


#Preview {
    NumberView(number: 1)
}
