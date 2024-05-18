//
//  NineSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/24.
//

import SwiftUI


struct AnalogClockView9: View {
    
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
                .foregroundColor(foreSecondColor)
                .shadow(color: foreThirdColor, radius: 10, x: 7, y: 7) // 向右下方偏移2个单位
            
            // For clock dial
            Circle()
                .foregroundColor(Color.white.opacity(0.1))
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
//
//              }

            // Creating the ticks
            Path { path in
                for index in 0..<60 {
                    let radian = Angle(degrees: Double(index) * 6 - 90).radians

                    if index % 15 == 0  {
                        let lineHeight: Double = index % 5 == 0 ? 12 : 10
                        
                        let x1 = centerX + innerRadius * cos(radian)
                        let y1 = centerY + innerRadius * sin(radian)
                        
                        let x2 = centerX + (innerRadius - lineHeight) * cos(radian)
                        let y2 = centerY + (innerRadius - lineHeight) * sin(radian)
                        
                        path.move(to: .init(x: x1, y: y1))
                        path.addLine(to: .init(x: x2, y: y2))
                    }
                }
            }
            .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
            .foregroundColor(foreThirdColor)
            
          
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
            .foregroundColor(foreThirdColor)
 
            
            // Drawing hour hand
            Path { path in
                path.move(to: center)
                  
                  let height = innerRadius * 0.45
                  
                  let radian = Angle(degrees: hour * 30 - 90).radians
                    _ = centerX + height * cos(radian)
                    _ = centerY + height * sin(radian)
                  
                // 计算时针的终点位置
                let angleOffset = (hour.truncatingRemainder(dividingBy:12) * 30) + Double(components.minute ?? 0) * 0.5 // 根据小时数和分钟数计算角度偏移
                
                let adjustedRadian = Angle(degrees: angleOffset - 90).radians
                let adjustedX = centerX + height * cos(adjustedRadian)
                let adjustedY = centerY + height * sin(adjustedRadian)
                
                path.addLine(to: CGPoint(x: adjustedX, y: adjustedY))
                
                
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .foregroundColor(foreThirdColor)
            
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
            .foregroundColor(Color.red)
            
            
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(foreThirdColor)
                .position(center)
        }
        .aspectRatio(1, contentMode: .fit)
        .onReceive(timer) { time in
            currentTime = time
            onUpdateTime?(time)
        }
    }
}





struct NineSwiftUIView: View {
    
    func hexToColor(hex: String, alpha: Double = 1.0) -> Color {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }
        
        let scanner = Scanner(string: formattedHex)
        var color: UInt64 = 0
        
        if scanner.scanHexInt64(&color) {
            let red = Double((color & 0xFF0000) >> 16) / 255.0
            let green = Double((color & 0x00FF00) >> 8) / 255.0
            let blue = Double(color & 0x0000FF) / 255.0
            return Color(red: red, green: green, blue: blue, opacity: alpha)
        } else {
            // 返回默认颜色，当转换失败时
            return Color.black
        }
    }
    
    @State private var themeColor: Color = .black
    @State private var currentTime: Date = Date.now
    @State private var foreSecondColor: Color = .red
    @State private var foreThirdColor: Color  = .gray
    @State private var isLandscape = false
//    267de9
//    f1eb4ehe
    
//    init() {
//      themeColor = hexToColor(hex: "#267de9")
//   }

   
    
    var body: some View {
        ZStack{
            VStack {
                AnalogClockView9(foregroundColor: $themeColor,foreSecondColor: $foreSecondColor,foreThirdColor:$foreThirdColor) { date in
                    currentTime = date
                }
                .rotationEffect(.degrees(!isLandscape ? 0 : 90))
                .padding(30)
                //            Text(currentTime, style: .time)
                //                .font(.system(size: 52))
                //                .fontWeight(.thin)
                //                .foregroundColor(hexToColor(hex: "afafaf"))
                
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                isLandscape = UIDevice.current.orientation.isLandscape

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(hexToColor(hex: "#d4d4d4"))
            .onAppear {
                self.foreThirdColor  = hexToColor(hex: "#afafaf") // 背景色
                //            self.foreSecondColor  = hexToColor(hex: "#267de9") //蓝色
                self.foreSecondColor = hexToColor(hex: "ebebeb") // 盘色
                self.foreThirdColor = hexToColor(hex: "a3a3a3") // 盘色
                
            }
//            VStack{
//                BuyButtonSwiftUIView()
//            }
        }
    }
      
}


#Preview {
    NineSwiftUIView()
}
