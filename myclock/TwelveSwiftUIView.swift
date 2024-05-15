//
//  TwelveSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/25.
//

import SwiftUI



struct AnalogClockView12: View {
    
    typealias AnalogClockCallback = (Date) -> Void
    
    @Binding var foregroundColor: Color
    @Binding var foreSecondColor: Color
    @Binding var foreThirdColor: Color
    @Binding var foreFourColor: Color
    @State private var currentTime: Date = Date.now
    @Binding var isShowSecond: Bool
    
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
    
    var onUpdateTime: AnalogClockCallback? = nil
    
    let borderWidth: CGFloat = 10
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
            //            hexToColor()
            // For clock dial
            //            Circle()
            //                .foregroundColor(hexToColor(hex: "#cbddf3"))
            //                .padding(borderWidth)
            Circle()
                .foregroundColor(.white)
                .padding(borderWidth)
            //
            
            
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
            ////                  let specialIndices = [1, 2, 4, 5, 7, 8, 10, 11]
            ////                  if specialIndices.contains(index) {
            ////                      Text("")
            ////                          .position(x: (x2 + x1) / 2, y: (y2 + y1) / 2)
            ////                          .foregroundColor(foregroundColor)
            ////                          .scaleEffect(0.75)
            ////                          .font(.system(size: 30))
            ////                  }else{
            //                      Text("\(index == 0 ? 12 : index)")
            //                          .position(x: (x2 + x1) / 2, y: (y2 + y1) / 2)
            //                          .foregroundColor(foregroundColor)
            //                          .scaleEffect(0.88)
            //                          .font(.system(size: 38))
            //                          .fontWeight(.bold)
            ////                  }
            //
            //              }
            
            // Creating the ticks
            Path { path in
                for index in 0..<60 {
                    let radian = Angle(degrees: Double(index) * 6 - 90).radians
                    
                    if index % 15 == 0 {
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
            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            
            // Drawing Minute hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.7
                
                let radian = Angle(degrees: minute * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing Minute hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.7
                
                let radian = Angle(degrees: minute * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 7, lineCap: .round))
            .foregroundColor(foreSecondColor)
            
            
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.45
                
                // 计算时针的终点位置
                let angleOffset = (hour.truncatingRemainder(dividingBy:12) * 30) + Double(components.minute ?? 0) * 0.5 // 根据小时数和分钟数计算角度偏移
                
                let adjustedRadian = Angle(degrees: angleOffset - 90).radians
                let adjustedX = centerX + height * cos(adjustedRadian)
                let adjustedY = centerY + height * sin(adjustedRadian)
                
                path.addLine(to: CGPoint(x: adjustedX, y: adjustedY))
                
                
            }
            .stroke(style: StrokeStyle(lineWidth:24, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing hour hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.45
                
                // 计算时针的终点位置
                let angleOffset = (hour.truncatingRemainder(dividingBy:12) * 30) + Double(components.minute ?? 0) * 0.5 // 根据小时数和分钟数计算角度偏移
                
                let adjustedRadian = Angle(degrees: angleOffset - 90).radians
                let adjustedX = centerX + height * cos(adjustedRadian)
                let adjustedY = centerY + height * sin(adjustedRadian)
                
                path.addLine(to: CGPoint(x: adjustedX, y: adjustedY))
                
                
            }
            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
            .foregroundColor(foreSecondColor)
            
            
            
            // Drawing Seconds hand
            //            Path { path in
            //                path.move(to: center)
            //
            //                let height = innerRadius - 20
            //
            //                let radian = Angle(degrees: second * 6 - 90).radians
            //                let x = centerX + height * cos(radian)
            //                let y = centerY + height * sin(radian)
            //
            //                path.addLine(to: CGPoint(x: x, y: y))
            //            }
            //            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
            //            .foregroundColor(foregroundColor)
            //
            
            // Drawing Seconds hand
            if isShowSecond {
                Path { path in
                    path.move(to: center)
                    
                    let height = innerRadius - 20
                    
                    let radian = Angle(degrees: second * 6 - 90).radians
                    let x = centerX + height * cos(radian)
                    let y = centerY + height * sin(radian)
                    
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                //            .foregroundColor(foreSecondColor)
                .foregroundColor(foregroundColor)
                
            }
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.black)
                .position(center)
            Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(foreFourColor)
                .position(center)
            
            
        }
        .aspectRatio(1, contentMode: .fit)
        .onReceive(timer) { time in
            currentTime = time
            onUpdateTime?(time)
        }
    }
}





struct TwelveSwiftUIView: View {
    
    @State private var themeColor: Color = .black
    @State private var currentTime: Date = Date.now
    @State private var changeRandomColor: Bool = false
    @State private var foreSecondColor: Color = .red
    @State private var foreThirdColor: Color  = .gray
    @State private var foreFourColor :  Color = .red
    private var colors: [String]
    private var colors2: [String]
    private var  colors3 : [String]
    
    @State private var isShowingCircles = false
    @State private var isShowSecond = true
    @State private var isButtonHidden = true
    @State private var isLandscape = false
    
    
    init() {
        colors = ["4e95f0", "#e84253","#eb8a33", "50df42",  "#33eb81","#33ebc6", "#33aceb",
                  "#335eeb","#4433eb","#7433eb","#a833eb","#eb33e0","#eb3385","eb335e",
                  "eb3333" , "#98c57a","916b59"
                 
        ]
        colors2 = ["#f4da2e", "#f2d558", "#e84253", "#e84253", "#e84253","#479fe5", "#f2d558","#e84253",
                   "#e84253", "#f4da2e", "#f2d558", "#f2d558", "#f2d558", "#f2d558","#f2d558", "#f2d558",
                 "fae14d"
        ]
        colors3 = ["#fd5a5a", "#fd5a5a", "#f2d558", "#f2d558", "#f2d558","#f2d558", "#d6602f","#f2d558",
                   "#f2d558",
                   "#fd5a5a", "#fd5a5a", "#fd5a5a", "#fd5a5a", "#fd5a5a","#fd5a5a", "#fd5a5a","#fd5a5a"
                  
        ]
//
    }
    
    
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
    
    
    var body: some View {
        ZStack{
        VStack {
            AnalogClockView12(
                foregroundColor: $themeColor,
                foreSecondColor: $foreSecondColor,
                foreThirdColor: $foreThirdColor,
                foreFourColor: $foreFourColor,
                isShowSecond: $isShowSecond
            ) { date in
                currentTime = date
              
            }

            .padding(30)
            if !isLandscape {
            Text(currentTime, style: .time)
                .font(.system(size: 52))
                .bold()
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(foreThirdColor)
        .onAppear {
            self.foreThirdColor  = hexToColor(hex: "4e95f0") // 背景色
            self.foreSecondColor  = hexToColor(hex: "#f4da2e") //蓝色
            self.themeColor = hexToColor(hex: "020001")// 文字指针
            self.foreFourColor = hexToColor(hex: "fd5a5a")// 文字指针
          
        } 
        .gesture(
            TapGesture()
                .onEnded { _ in
                    self.isButtonHidden.toggle()
                }
        )
        
        
            VStack{
                Spacer()
                if isButtonHidden && isShowingCircles {
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
                                        self.foreThirdColor = hexToColor(hex: colors[index])
                                        self.foreSecondColor = hexToColor(hex: colors2[index])
                                        self.foreFourColor = hexToColor(hex:  colors3[index])
                                        
                                    }.overlay(
                                        Circle()
                                            .stroke(hexToColor(hex: colors2[index]), lineWidth: 4)
                                    )
                            }
                        }.padding()
                    }
                    .padding()
                }
                
                
                if isButtonHidden { HStack{
                    
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
                            //                                    isShowDividingRule = isShowDividingRule == 3 ? 0 : isShowDividingRule + 1
                            //
                            isShowSecond.toggle()
                            
                        }
                    }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                }  }}.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    isLandscape = UIDevice.current.orientation.isLandscape
     
                }
            
            VStack{  
                BuyButtonSwiftUIView()
            }.offset(y:-40)
        }
        
//        .foregroundColor(hexToColor(hex:"192d32"))
//        .background(hexToColor(hex:"d4be87"))
    }
  
}

#Preview {
    TwelveSwiftUIView()
}
