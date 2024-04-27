//
//  FiveSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/24.
//

import SwiftUI



#Preview {
    FiveSwiftUIView()
}

//
//  TwoSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/24.
//

import SwiftUI



struct AnalogClockView5: View {
    
    typealias AnalogClockCallback = (Date) -> Void
    
    @Binding var foregroundColor: Color
    @Binding var foreSecondColor: Color
    @Binding var foreThirdColor: Color
    @State private var currentTime: Date = Date.now
    
    var onUpdateTime: AnalogClockCallback? = nil
    
    let borderWidth: CGFloat = 16
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
//            let second = Double(components.second ?? 0)
            
            // Using this circle for creating the border
            Circle()
                .foregroundColor(foregroundColor)
               
            
            // For clock dial
            Circle()
                .foregroundColor(.white)
                .padding(borderWidth)
               
            // Creating the ticks
//              ForEach(0..<12) { index in
//                  let radian = Angle(degrees: Double(index) * 30 - 90).radians
//                  
//                  let x1 = centerX + innerRadius * cos(radian)
//                  let y1 = centerY + innerRadius * sin(radian)
//                  
//                  let x2 = centerX + (innerRadius - 10) * cos(radian)
//                  let y2 = centerY + (innerRadius - 10) * sin(radian)
//                  
//                  let specialIndices = [1, 2, 4, 5, 7, 8, 10, 11]
//                  if specialIndices.contains(index) {
//                      Text("")
//                          .position(x: (x2 + x1) / 2, y: (y2 + y1) / 2)
//                          .foregroundColor(foregroundColor)
//                          .scaleEffect(0.75)
//                          .font(.system(size: 30))
//                  }else{
//                      Text("\(index == 0 ? 12 : index)")
//                          .position(x: (x2 + x1) / 2, y: (y2 + y1) / 2)
//                          .foregroundColor(foregroundColor)
//                          .scaleEffect(0.88)
//                          .font(.system(size: 38))
//                          .fontWeight(.bold)
//                  }
                
//              }
//
//             Creating the ticks
            Path { path in
                for index in 0..<60 {
                    let radian = Angle(degrees: Double(index) * 6 - 90).radians

                    if index % 5 == 0 {
                        let lineHeight: Double = index % 5 == 0 ? 30 : 0

                        let x1 = centerX + innerRadius * cos(radian)
                        let y1 = centerY + innerRadius * sin(radian)

                        let x2 = centerX + (innerRadius - lineHeight) * cos(radian)
                        let y2 = centerY + (innerRadius - lineHeight) * sin(radian)

                        path.move(to: .init(x: x1, y: y1))
                        path.addLine(to: .init(x: x2, y: y2))
                    }
                }
            }
            .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
            .scaleEffect(0.82)
            .foregroundColor(foreThirdColor)
            
           
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
                  
                  let height = innerRadius * 0.27
                  
//                  let radian = Angle(degrees: hour * 30 - 90).radians
               
                  
                // 计算时针的终点位置
                let angleOffset = (hour.truncatingRemainder(dividingBy:12) * 30) + Double(components.minute ?? 0) * 0.5 // 根据小时数和分钟数计算角度偏移
                
                let adjustedRadian = Angle(degrees: angleOffset - 90).radians
                let adjustedX = centerX + height * cos(adjustedRadian)
                let adjustedY = centerY + height * sin(adjustedRadian)
                
                path.addLine(to: CGPoint(x: adjustedX, y: adjustedY))
                
                
            }
            .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            
            
            
            // Drawing Minute hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.4
                
                let radian = Angle(degrees: minute * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            
            // Drawing Seconds hand
//            Path { path in
//                path.move(to: center)
//                
//                let height = innerRadius - 85
//                
//                let radian = Angle(degrees: second * 6 - 90).radians
//                let x = centerX + height * cos(radian)
//                let y = centerY + height * sin(radian)
//                
//                path.addLine(to: CGPoint(x: x, y: y))
//            }
//            .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round))
//            .foregroundColor(foreSecondColor)
//         
            
//            Circle()
//                .frame(width: 24, height: 24)
//                .foregroundColor(foreSecondColor)
//                .position(center)
        }
        .aspectRatio(1, contentMode: .fit)
        .onReceive(timer) { time in
            currentTime = time
            onUpdateTime?(time)
        }
    }
}





struct FiveSwiftUIView: View {
    
    @State private var themeColor: Color = .black
    @State private var currentTime: Date = Date.now
    @State private var changeRandomColor: Bool = false
    @State private var foreSecondColor: Color = .red
    @State private var foreThirdColor: Color  = .black
    private var colors: [Color]
    
    init() {
        colors = [.red, .yellow, .black, .green, .orange, .blue]
    }
    
    var body: some View {
        VStack {
            AnalogClockView5(foregroundColor: $themeColor,foreSecondColor: $foreSecondColor,foreThirdColor:$foreThirdColor) { date in
                currentTime = date
                if changeRandomColor {
                    themeColor = colors.randomElement() ?? themeColor
                }
            }
//            .shadow(color: Color.black.opacity(0.15),radius: 32)
            .padding(30)
//            Text(currentTime, style: .time)
//                .font(.system(size: 52))
//                .bold().foregroundColor(themeColor)
//            Toggle(isOn: $changeRandomColor) {
//                Text("Change Color")
//            }
//            .padding(.horizontal, 30)
//            Spacer(minLength: 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}



