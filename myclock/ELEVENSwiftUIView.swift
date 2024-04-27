//
//  ELEVENSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/25.
//

import SwiftUI



struct AnalogClockView11: View {
    
    typealias AnalogClockCallback = (Date) -> Void
    
    @Binding var foregroundColor: Color
    @Binding var foreSecondColor: Color
    @Binding var foreThirdColor: Color
    @State private var currentTime: Date = Date.now
    
    var onUpdateTime: AnalogClockCallback? = nil
    
    let borderWidth: CGFloat = 6
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            let radius = geometry.size.width / 2
            let innerRadius = radius - borderWidth
            let romanNumerals: [String] = ["XII", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X","XI", ]
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            
            let center = CGPoint(x: centerX, y: centerY)
            
            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: currentTime)
            
            let hour = Double(components.hour ?? 0)
            let minute = Double(components.minute ?? 0)
            let second = Double(components.second ?? 0)
            
            // Using this circle for creating the border
            Circle()
                .foregroundColor(.black)
//
            // For clock dial
            Circle()
                .foregroundColor(.white)
                .padding(borderWidth)
//            Circle()
//                .foregroundColor(.white)
//                .padding(borderWidth)
//                .scaleEffect(0.5)
            
            Circle()
                .stroke(Color.black, lineWidth: 12) // 设置边框颜色为黑色，边框厚度为5
                .scaleEffect(0.52)
//                        .frame(width: 40, height: 40) // 设置圆环的尺寸为半径为20的圆

            
            ForEach(0..<12) { index in

                let radian = Angle(degrees: Double(index) * 30 - 90).radians

                  let x1 = centerX + innerRadius * cos(radian)
                  let y1 = centerY + innerRadius * sin(radian)

                  let x2 = centerX + (innerRadius - 10) * cos(radian)
                  let y2 = centerY + (innerRadius - 10) * sin(radian)

          

                Text("\(romanNumerals[index])")
                    .scaleEffect(x: 0.5, y: 1.7)
//                    .scaleEffect(0.8)
                    .rotationEffect(Angle(degrees: Double(index) * 30))
                    .position(x: (x2 + x1) / 2, y: (y2 + y1) / 2)
                    .foregroundColor(foregroundColor)
//                    .rotationEffect(Angle(radians: reflectAngle + .pi/2))
                    .font(.system(size: 80))
                    .scaleEffect(0.8)
                    .fontWeight(.bold)
//                    .font(.custom("", size: 80))

            }


            // Drawing Seconds hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius - 30
                
                let radian = Angle(degrees: second * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing Minute hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.6
                
                let radian = Angle(degrees: minute * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing hour hand
            Path { path in

                path.move(to: center)
                  
                  let height = innerRadius * 0.4
                  
          
                // 计算时针的终点位置
                let angleOffset = (hour.truncatingRemainder(dividingBy:12) * 30) + Double(components.minute ?? 0) * 0.5 // 根据小时数和分钟数计算角度偏移
                
                let adjustedRadian = Angle(degrees: angleOffset - 70).radians
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





struct ELEVENSwiftUIView: View {
    
    @State private var themeColor: Color = .black
    @State private var currentTime: Date = Date.now
    @State private var changeRandomColor: Bool = false
    @State private var foreSecondColor: Color = .red
    @State private var foreThirdColor: Color  = .gray
    private var colors: [Color]
    
    init() {
        colors = [.red, .yellow, .black, .green, .orange, .blue]
    }
    
    var body: some View {
        ZStack{
            VStack {
                AnalogClockView11(foregroundColor: $themeColor,foreSecondColor: $foreSecondColor,foreThirdColor:$foreThirdColor) { date in
                    currentTime = date
                    if changeRandomColor {
                        themeColor = colors.randomElement() ?? themeColor
                    }
                }
                .padding(30)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            
            VStack{
                BuyButtonSwiftUIView()
            }
        }
    }
}




#Preview {
    ELEVENSwiftUIView()
}


