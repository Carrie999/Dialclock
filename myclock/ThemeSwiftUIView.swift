//
//  ThemeSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/22.
//

import SwiftUI


struct Rect: View {
    @Binding var theme: String
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(ModelData.self) var modelData
    @ObservedObject var textBasedModel = ClockModel { $0 }
 
    
    var landmark: Landmark
    //    var index: Int
    var filteredLandmarks: [Landmark] {
        modelData.landmarks
    }
    @ViewBuilder
    func flipViewAtIndex1(idx: Int,backgroundColor: String,textColor: String) -> some View {
        
        let config = FlipTextViewConfig(
            backgroundColor: hexToColor(hex:backgroundColor,alpha:1.0),
            textColor: hexToColor(hex:textColor,alpha:1.0),
            fontSize: 200.0,
            animationDuration: 0.4)
        FlipTextView($textBasedModel.values[idx], config: config)
        
    }
    var body: some View {
        ZStack{

         
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                //            .stroke(Color.white, lineWidth:  !theme.isEmpty && theme == String(landmark.id) ?2:0)
                    .foregroundColor(hexToColor(hex:landmark.themeBackgroundColor,alpha:1.0))
                    .frame( height:160)
                    .overlay(
                        HStack(spacing: -70){
                         
                            Spacer()
                            HStack(spacing: 0) {
                                flipViewAtIndex1(idx:0,
                                                 backgroundColor:landmark.themeBgSecondColor,
                                                 textColor:landmark.themeTextColor
                                ).padding(.leading,20)
                                flipViewAtIndex1(idx:1,
                                                 backgroundColor:landmark.themeBgSecondColor,
                                                 textColor:landmark.themeTextColor
                                ).padding(.trailing,20)
                            }.background( hexToColor(hex:landmark.themeBgSecondColor,alpha:1.0)).cornerRadius(20.0)
                                .overlay(
                                    content:{
                                        Rectangle()
                                            .frame(height:4).foregroundColor(hexToColor(hex:landmark.themeBackgroundColor,alpha:1.0))
                                    }).scaleEffect(0.6)
                            
                            
                            HStack(spacing: 0) {
                                flipViewAtIndex1(idx:2,
                                                 backgroundColor:landmark.themeBgSecondColor,
                                                 textColor:landmark.themeTextColor
                                ).padding(.leading,20)
                                flipViewAtIndex1(idx:3,
                                                 backgroundColor:landmark.themeBgSecondColor,
                                                 textColor:landmark.themeTextColor
                                ).padding(.trailing,20)
                            }.background( hexToColor(hex:landmark.themeBgSecondColor,alpha:1.0)).cornerRadius(20.0)
                                .overlay(
                                    content:{
                                        Rectangle()
                                            .frame(height:4).foregroundColor(hexToColor(hex:landmark.themeBackgroundColor,alpha:1.0))
                                    }
                                ).scaleEffect(0.6)
                            Spacer()
                            
                            
                        }
                    )
                    .overlay(
                        //                HStack{
                        //                    if !theme.isEmpty && theme == String(landmark.id) {
                        //
                        //                        Text("User name: \(theme)")
                        //                        Image(systemName: "checkmark")
                        //                                  .foregroundColor(.green) // 设置图标颜色
                        //                                  .font(.system(size: 50)) // 设置图标大小
                        //                    } else {
                        ////                        Text("User name not found")
                        //                    }
                        //                }
                        
                        
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(!theme.isEmpty && theme == String(landmark.id) ? Color.white: Color.clear, lineWidth: 2)
                    )
                    .onAppear {
                        //                if let savedUserName = UserDefaults.standard.string(forKey: "theme") {
                        //                    var theme = savedUserName
                        //                }
                    }
                
                    .padding(.horizontal,20)
                    .padding(.vertical,10)
                    .onTapGesture {
                        self.theme = String(landmark.id)
                        
                        //                theme = filteredLandmarks.firstIndex(where: { $0.id == landmark.id })
                        
                        //                UserDefaults.standard.set("theme", forKey: String(landmark.id) )
                        
                        //                landmark.id
                        //                 filteredLandmarks[index].isFavorite.toggle()
                        UserDefaults.standard.set(landmark.themeTextColor, forKey: "textColor")
                        UserDefaults.standard.set(landmark.themeBackgroundColor, forKey: "backgroundColor")
                        UserDefaults.standard.set(landmark.themeBgSecondColor, forKey: "bgSecondColor")
                        self.themeManager.themeTextColor =
                        hexToColor(hex:landmark.themeTextColor,alpha:1.0)

                        self.themeManager.themeBackgroundColor = hexToColor(hex:landmark.themeBackgroundColor, alpha:1.0)
                        
                        self.themeManager.themeBgSecondColor =
                        hexToColor(hex:landmark.themeBgSecondColor, alpha:1.0)
                    }
        }
        
    }
    
}




struct ThemeSwiftUIView: View {
    @State var theme: String = ""
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(ModelData.self) var modelData
    @State private var isTapped = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var now = Date()

    var filteredLandmarks: [Landmark] {
        modelData.landmarks
    }
    
    
    
    
    var body: some View {
        VStack {
            
 
                HStack(alignment: .center,spacing:20){
                    
                    Text("返回")
                        .opacity(0)
                        .padding()
                    Spacer()
                    Text("更换皮肤").font(.headline)
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("完成")
                    }.padding()
                    
                }
                
                ScrollView{
                    ForEach(filteredLandmarks) { landmark in
                        //                    ForEach(Array(filteredLandmarks.enumerated()), id: \.landmark) { index, landmark in
                        Rect(theme:$theme,landmark:landmark)
                    }
                }
                 
           
            
            
            
            
            
            
        }
        .navigationBarHidden(true)
        .navigationTitle("更换皮肤")
        .foregroundColor(Color.white)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.customBlack)
        .navigationBarItems(
            //                leading: NavigationLink(  destination: ContentView(),label:{Image(systemName: "person.fill")}),
            trailing: NavigationLink(
                destination: ContentView(),
                label: {
                    Image(systemName: "pencil")
                }
            )
        )
    }
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
#Preview {
    ThemeSwiftUIView().environment(ModelData()).environmentObject(ThemeManager(themeTextColor: .black, themeBackgroundColor: .red
                                                                               ,themeBgSecondColor:Color.customRed))
}
