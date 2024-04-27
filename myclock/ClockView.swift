import SwiftUI

struct ClockView: View {
  var isTextBased = true
  var innerSpacing = 0.0
  var outerSpacing = 8.0
  @EnvironmentObject var themeManager: ThemeManager
  @ObservedObject var textBasedModel = ClockModel { $0 }
  @ObservedObject var imageBasedModel = ClockModel { Int(String($0)) ?? 0 }
//  @Binding var isLandscape: Bool // 在子视图中声明一个绑定变量
  @State var isLandscape: Bool = false
  var imageScale = 1.0

    
  var body: some View {
      
      VStack {
      if(!isLandscape){
          VStack(spacing: outerSpacing) {
              HStack(spacing: innerSpacing) {
                  flipViewAtIndex(0).padding(.leading,20)
                  flipViewAtIndex(1).padding(.trailing,20)
              }.background(themeManager.themeBgSecondColor).cornerRadius(20.0)
                  .overlay(
                    content:{
                        Rectangle().frame(height:4).foregroundColor(themeManager.themeBackgroundColor)
                    }
                  )
              
              HStack(spacing: innerSpacing) {
                  flipViewAtIndex(2).padding(.leading,20)
                  flipViewAtIndex(3).padding(.trailing,20)
              }.background(themeManager.themeBgSecondColor).cornerRadius(20.0).overlay(
                content:{
                    Rectangle().frame(height:4).foregroundColor(themeManager.themeBackgroundColor)
                }
              )
              
              HStack(spacing: innerSpacing) {
                  
                  flipViewAtIndex(4).padding(.leading,20)
                  flipViewAtIndex(5).padding(.trailing,20)
              }.background(themeManager.themeBgSecondColor).cornerRadius(20.0).overlay(
                content:{
                    Rectangle().frame(height:4).foregroundColor(themeManager.themeBackgroundColor)
                }
              )
              
          }
      }else{
          
          HStack(spacing: outerSpacing) {
              Spacer()
              HStack(spacing: innerSpacing) {
                  flipViewAtIndex(0).padding(.leading,20)
                  flipViewAtIndex(1).padding(.trailing,20)
              }.background(themeManager.themeBgSecondColor).cornerRadius(20.0)
                  .overlay(
                    content:{
                        Rectangle().frame(height:4).foregroundColor(themeManager.themeBackgroundColor)
                    }
                  )
              Spacer()
              HStack(spacing: innerSpacing) {
                  flipViewAtIndex(2).padding(.leading,20)
                  flipViewAtIndex(3).padding(.trailing,20)
              }.background(themeManager.themeBgSecondColor).cornerRadius(20.0).overlay(
                content:{
                    Rectangle().frame(height:4).foregroundColor(themeManager.themeBackgroundColor)
                }
              )
              Spacer()
              
              HStack(spacing: innerSpacing) {
                  
                  flipViewAtIndex(4).padding(.leading,20)
                  flipViewAtIndex(5).padding(.trailing,20)
              }.background(themeManager.themeBgSecondColor).cornerRadius(20.0).overlay(
                content:{
                    Rectangle().frame(height:4).foregroundColor(themeManager.themeBackgroundColor)
                }
              )
              Spacer()
              
          }
      }
      }.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
          isLandscape = UIDevice.current.orientation.isLandscape

      }
      
      
      
      
      
      
  }

  @ViewBuilder
  func flipViewAtIndex(_ idx: Int) -> some View {
    if isTextBased {
      let config = FlipTextViewConfig(backgroundColor: themeManager.themeBgSecondColor,
                                      textColor: themeManager.themeTextColor,
                                      fontSize: 200.0,
                                      animationDuration: 0.4)
      FlipTextView($textBasedModel.values[idx], config: config)
    } else {
       
      FlipImageView($imageBasedModel.values[idx],
                    scale: imageScale,
                    animationDuration: 0.66)
    }
  }
}

struct ClockView_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 50.0) {
       
        
        ClockView(isTextBased: true)
//      ClockView(isTextBased: false, imageScale: 0.6)
    }
//    .macOnlyPadding(100.0)
    .environmentObject(ThemeManager(themeTextColor: .black, themeBackgroundColor: .red,themeBgSecondColor: Color.customRed))
  }
}
