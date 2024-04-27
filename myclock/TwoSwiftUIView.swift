//
//  TwoSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/24.
//

import SwiftUI



struct AnalogClockView: View {
    
    typealias AnalogClockCallback = (Date) -> Void
    
    @Binding var foregroundColor: Color
    @Binding var foreSecondColor: Color
    @Binding var foreThirdColor: Color
    @State private var currentTime: Date = Date.now
    
    var onUpdateTime: AnalogClockCallback? = nil
    
    let borderWidth: CGFloat = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            let radius = geometry.size.width / 2
            let innerRadius = radius - borderWidth
            
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            
            let center = CGPoint(x: centerX, y: centerY)
            
            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: currentTime)
            
            let hour = Double(components.hour ?? 0)
            let minute = Double(components.minute ?? 0)
            let second = Double(components.second ?? 0)
            
            // Using this circle for creating the border
            Circle()
                .foregroundColor(foregroundColor)
            
            // For clock dial
            Circle()
                .foregroundColor(.white)
                .padding(borderWidth)
            
            // Creating the ticks
              ForEach(0..<12) { index in
                  let radian = Angle(degrees: Double(index) * 30 - 90).radians
                  
                  let x1 = centerX + innerRadius * cos(radian)
                  let y1 = centerY + innerRadius * sin(radian)
                  
                  let x2 = centerX + (innerRadius - 10) * cos(radian)
                  let y2 = centerY + (innerRadius - 10) * sin(radian)
                  
//                  let specialIndices = [1, 2, 4, 5, 7, 8, 10, 11]
//                  if specialIndices.contains(index) {
//                      Text("")
//                          .position(x: (x2 + x1) / 2, y: (y2 + y1) / 2)
//                          .foregroundColor(foregroundColor)
//                          .scaleEffect(0.75)
//                          .font(.system(size: 30))
//                  }else{
                      Text("\(index == 0 ? 12 : index)")
                          .position(x: (x2 + x1) / 2, y: (y2 + y1) / 2)
                          .foregroundColor(foregroundColor)
                          .scaleEffect(0.88)
                          .font(.system(size: 38))
                          .fontWeight(.bold)
//                  }
                
              }

            // Creating the ticks
//            Path { path in
//                for index in 0..<60 {
//                    let radian = Angle(degrees: Double(index) * 6 - 90).radians
//                    
//                    let lineHeight: Double = index % 5 == 0 ? 25 : 10
//                    
//                    let x1 = centerX + innerRadius * cos(radian)
//                    let y1 = centerY + innerRadius * sin(radian)
//                    
//                    let x2 = centerX + (innerRadius - lineHeight) * cos(radian)
//                    let y2 = centerY + (innerRadius - lineHeight) * sin(radian)
//                    
//                    path.move(to: .init(x: x1, y: y1))
//                    path.addLine(to: .init(x: x2, y: y2))
//                }
//            }
//            .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
//            .foregroundColor(foreThirdColor)
            
            // Drawing Seconds hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius - 20
                
                let radian = Angle(degrees: second * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
            .foregroundColor(foreSecondColor)
            
            // Drawing Minute hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.7
                
                let radian = Angle(degrees: minute * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing hour hand
            Path { path in
//                path.move(to: center)
//                
//                let height = innerRadius * 0.45
//                
//                let radian = Angle(degrees: hour * 30 - 90).radians
//                let x = centerX + height * cos(radian)
//                let y = centerY + height * sin(radian)
//                
//                path.addLine(to: CGPoint(x: x, y: y))
                path.move(to: center)
                  
                  let height = innerRadius * 0.45
                  
//                  let radian = Angle(degrees: hour * 30 - 90).radians
                // 计算时针的终点位置
                let angleOffset = (hour.truncatingRemainder(dividingBy:12) * 30) + Double(components.minute ?? 0) * 0.5 // 根据小时数和分钟数计算角度偏移
                
                let adjustedRadian = Angle(degrees: angleOffset - 90).radians
                let adjustedX = centerX + height * cos(adjustedRadian)
                let adjustedY = centerY + height * sin(adjustedRadian)
                
                path.addLine(to: CGPoint(x: adjustedX, y: adjustedY))
                
                
            }
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(foregroundColor)
                .position(center)
        }
        .aspectRatio(1, contentMode: .fit)
        .onReceive(timer) { time in
            currentTime = time
            onUpdateTime?(time)
        }
    }
}





struct TwoSwiftUIView: View {
    
    @State private var themeColor: Color = .black
    @State private var currentTime: Date = Date.now

    @State private var foreSecondColor: Color = .red
    @State private var foreThirdColor: Color  = .gray
    private var colors: [Color]
    
    init() {
        colors = [.red, .yellow, .black, .green, .orange, .blue]
    }
    
    var body: some View {
        ZStack{
            VStack {
                AnalogClockView(foregroundColor: $themeColor,foreSecondColor: $foreSecondColor,foreThirdColor:$foreThirdColor) { date in
                    currentTime = date
                   
                }
                .padding(30)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(themeColor.opacity(1))
                
            VStack{
              
                HStack {
                    Spacer()
                    NavigationLink(destination: SettingSwiftUIView()) {
                  
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                            .shadow(color: Color.black.opacity(1), radius: 3, x: 0, y: 2)
         
                    
                    }
                }
                
                
                Spacer()
                
                
            }
            
        
        }
    }
}



#Preview {
    TwoSwiftUIView()
}
