//
//  ContentView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/22.
//

import SwiftUI


struct ContentView: View {
    @Environment(ModelData.self) var modelData
    @EnvironmentObject var themeManager: ThemeManager
    
    
    var body: some View {
        Clock7SSwiftUIView()
    }
}



struct OneView: View {
    @Environment(ModelData.self) var modelData
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isButtonHidden = false
    @State private var isPresented = false
    @State private var isLandscape = false

    var body: some View {
        
        NavigationView {
            
            if !isLandscape {
                ZStack{
                    
                    VStack(spacing: 10.0) {
                        
                        ClockView(isTextBased: true)
                        Spacer()
                    }
                    .padding(100.0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(themeManager.themeBackgroundColor)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                self.isButtonHidden.toggle()
                            }
                    )
                    
                    VStack {
                        Spacer()
                        if !isButtonHidden {
                            Spacer().frame(height:20)
                            Button(action: {
                                
                            }) {
                                
                                NavigationLink(destination: ThemeSwiftUIView()) {
                                    Image(systemName: "paintpalette.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:30, height: 30)
                                        .foregroundColor(.white)
                                    
                                        .padding()
                                }
                                
                            }.padding()
                            
                            
                        }
                        Spacer().frame(height:20)
                    }
                }
            } else {
                ZStack {
                HStack(spacing: 10.0) {
                    
                    ClockView(isTextBased: true)
                    Spacer()
                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(themeManager.themeBackgroundColor)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            self.isButtonHidden.toggle()
                        }
                )
                
                
                
                HStack {
                    VStack{
                        Spacer()
                        if !isButtonHidden {
                            Button(action: {
                                
                                
                            }) {
                                
                                NavigationLink(destination: ThemeSwiftUIView()) {
                                    Image(systemName: "paintpalette.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:30, height: 30)
                                        .foregroundColor(.white)
                                    
                                        .padding()
                                }
                                
                            }.padding()
                            
                            
                        }
                        
                    }
                    
                }
                
                }
            }
            
            
            
        }.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            isLandscape = UIDevice.current.orientation.isLandscape
            
        }
        
        
        
    }
}



struct Clock7SSwiftUIView: View {
    @State private var currentIndex = 0
    
    let views: [AnyView] = [
        AnyView(TwoSwiftUIView()),
        AnyView(OneView()),
        AnyView(SixSwiftUIView()),
        AnyView(TwelveSwiftUIView()),
        AnyView(FourSwiftUIView()),
        AnyView(ThreeSwiftUIView()),
        AnyView(FiveSwiftUIView()),
        AnyView(SevenSwiftUIView()),
        AnyView(NineSwiftUIView()),
        AnyView(EightSwiftUIView()),
        AnyView(TenSwiftUIView()),
        AnyView(ELEVENSwiftUIView()),
        
    ]
    
    var body: some View {
        NavigationView {
        ZStack {
            ForEach(views.indices, id: \.self) { index in
                self.views[index]
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.slide)
                    .offset(x: CGFloat(index - self.currentIndex) * UIScreen.main.bounds.width)
            }
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        let offset = gesture.translation.width
                        //                        let screenWidth = UIScreen.main.bounds.width
                        if self.currentIndex == 0 && offset > 0 {
                            // 在第一页且向右滑动时没有效果
                            return
                        }
                        if self.currentIndex == self.views.count - 1 && offset < 0 {
                            // 在最后一页且向左滑动时没有效果
                            return
                        }
                        if offset < -50 {
                            // 从右往左滑动到下一个视图
                            withAnimation {
                                self.currentIndex = (self.currentIndex + 1) % self.views.count
                            }
                        } else if offset > 50 {
                            // 从左往右滑动到上一个视图
                            withAnimation {
                                self.currentIndex = (self.currentIndex - 1 + self.views.count) % self.views.count
                            }
                        }
                    }
            )
        }
    }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(ModelData()).environmentObject(
            ThemeManager(themeTextColor: .white,
                         themeBackgroundColor: .black,
                         themeBgSecondColor:Color.customBlack))
        
        
        //        ContentView().preferredColorScheme(.dark)
    }
}
