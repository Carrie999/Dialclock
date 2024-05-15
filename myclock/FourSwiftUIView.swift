//
//  ThreeSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/24.
//

import SwiftUI


struct AnalogClockView2: View {
    
    typealias AnalogClockCallback = (Date) -> Void
    
    @Binding var foregroundColor: Color
    @Binding var foreSecondColor: Color
    @Binding var foreThirdColor: Color
    @Binding var isShowDividingRule : Int
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
            
            
            
            // Creating the ticks
            Path { path in
                for index in 0..<60 {
                    let radian = Angle(degrees: Double(index) * 6 - 90).radians
                    if isShowDividingRule == 1 {
                        let lineHeight: Double = index % 5 == 0 ? 25 : 10

                        let x1 = centerX + innerRadius * cos(radian)
                        let y1 = centerY + innerRadius * sin(radian)

                        let x2 = centerX + (innerRadius - lineHeight) * cos(radian)
                        let y2 = centerY + (innerRadius - lineHeight) * sin(radian)

                        path.move(to: .init(x: x1, y: y1))
                        path.addLine(to: .init(x: x2, y: y2))
                    }
                    if isShowDividingRule == 2 && index % 5 == 0 {
                       
                        let lineHeight: Double = index % 5 == 0 ? 25 : 10

                        let x1 = centerX + innerRadius * cos(radian)
                        let y1 = centerY + innerRadius * sin(radian)

                        let x2 = centerX + (innerRadius - lineHeight) * cos(radian)
                        let y2 = centerY + (innerRadius - lineHeight) * sin(radian)

                        path.move(to: .init(x: x1, y: y1))
                        path.addLine(to: .init(x: x2, y: y2))
                    }
                    if isShowDividingRule == 3 && index % 15 == 0 {
                       
                        let lineHeight: Double = index % 5 == 0 ? 25 : 10

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
            .foregroundColor(foreThirdColor.opacity(0.4))
            
            
            // Drawing Minute hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.7
                
                let radian = Angle(degrees: minute * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
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
            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
            .foregroundColor(foreThirdColor)
            
            // Drawing Seconds hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius - 20
                
                let radian = Angle(degrees: second * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .foregroundColor(foreThirdColor)
            
            
            Circle()
                .frame(width: 18, height: 18)
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





struct FourSwiftUIView: View {
    
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
    @State private var isShowingCircles = false
    @State private var isShowDividingRule: Int  = 0
    @State private var isButtonHidden = false
    private var colors: [String]
    private var colors2: [String]
    @State private var isLandscape = false
    
    init() {
        colors = ["#267de9",
                 "439492","84b57f", "5f9abc","84a2f8","b192f8",
                  "#ef8b88",
                  "#95acea","#7cbf8a","#9bc4bb","#abc49b","c49b9b","9ba1c4" ,"#c4c49b",
                  "#112e33", "#45543d","#463128", "464428",  "#2d2846","#442846", "#411515", 
                 
        ]
        colors2 = ["f1eb4ehe",
                   "e7e6d4","cde09b","f6d891","f1f2d0","ebe6f8",
                   "#fdfaf2",
                   "#fdfaf2", "#fdfaf2","#fdfaf2","#f5fdf2", "#f5fdf2","#f5fdf2","#fdfcf2",
                   "#e9cca4", "#d9b27c", "d9bd7f", "d9bd7f","d9bd7f", "d9bd7f","e9cca4",
                 
                  
        ]
    }
    
    var body: some View {
        ZStack{
            VStack {
                AnalogClockView2(foregroundColor: $themeColor,
                                 foreSecondColor: $foreSecondColor,
                                 foreThirdColor: $foreThirdColor,
                                 isShowDividingRule: $isShowDividingRule
                ) { date in currentTime = date }
                .padding(30)
                if !isLandscape { Text(currentTime, style: .time)
                        .font(.system(size: 52))
                        .bold().foregroundColor(self.foreSecondColor)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(self.foreThirdColor)
            .onAppear {
                self.foreThirdColor  = hexToColor(hex: "#267de9") //蓝色
                self.foreSecondColor = hexToColor(hex: "f1eb4ehe") //黄色
            }
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        self.isButtonHidden.toggle()
                    }
            )
            
            VStack{
                Spacer()
                
                if !isButtonHidden && isShowingCircles {
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(0..<colors.count, id: \.self) { index in
                                Circle()
                                    .fill(hexToColor(hex: colors[index]))
                                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                                    .frame(width: 30, height: 30)
                                    .transition(.scale)
                                //                                           .border(hexToColor(hex: colors2[index]), width: 4)
                                    .onTapGesture {
                                        self.foreThirdColor  = hexToColor(hex: colors[index]) //蓝色
                                        self.foreSecondColor = hexToColor(hex: colors2[index]) //黄色
                                    }.overlay(
                                        Circle()
                                            .stroke(hexToColor(hex: colors2[index]), lineWidth: 4)
                                    )
                            }
                        }.padding()
                    }
                    .padding()
                }
                
                if !isButtonHidden { HStack{
                    Button(action: {
                        if !UserDefaults.standard.bool(forKey: "isPurchased"){
                            return
                        }
                        withAnimation {
                            isShowingCircles.toggle()
                            
                        }
                    }) {
                        Image(systemName: "paintpalette.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                    
                    Button(action: {
                        if !UserDefaults.standard.bool(forKey: "isPurchased"){
                            return
                        }
                        withAnimation {
                            isShowDividingRule = isShowDividingRule == 3 ? 0 : isShowDividingRule + 1
                            
                            
                        }
                    }) {
                        Image(systemName: "dial.low.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                    
                }
                    
                    
                }
                
                
                
            }
            
            
            VStack{
                BuyButtonSwiftUIView()
            }.offset(y:-40)
            
        }.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            isLandscape = UIDevice.current.orientation.isLandscape

        }
        
        
        
        
        
    }
    
}



#Preview {
    FourSwiftUIView()
}
