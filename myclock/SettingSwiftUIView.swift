//
//  SettingSwiftUIView.swift
//  myclock
//
//  Created by  玉城 on 2024/4/26.
//

import SwiftUI
import MessageUI
import AppIntents
import StoreKit

struct SettingSwiftUIView: View {
    @State private var isShowingMailView = false
    @State private var isShowingActivityView = false
//    @Environment(\.requestReview) var requestReview
    
    
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
    
    let textToShare = "Hello, friends! Check out this cool app!"
//    private func mailView() -> some View {
//          MFMailComposeViewController.canSendMail() ?
//              AnyView(MailView(isShowing: $isShowingMailView, result: $result)) :
//              AnyView(Text("Can't send emails from this device"))
//      }
//  }

    func getAppShareText() -> String {
          // Customize the share text with your app's description
//          return "Check out this amazing app! It's the best app ever about clock!"
        return "Check out this amazing app! It's the best app ever about clock!"
      }
    func getAppStoreLink() -> URL {
            // Replace "your_app_id" with your actual App Store ID
            let appStoreID = "6502540017"
            let appStoreURL = "https://apps.apple.com/app/id\(appStoreID)?action=write-review"
            return URL(string: appStoreURL)!
        }
    var body: some View {
//        NavigationView {
            List {
                
                Section(header: Text("升级版")) {
                  
                    
                    if UserDefaults.standard.bool(forKey: "isPurchased") {
                        Text("您已是升级版")
                            .padding()
                            .foregroundColor(hexToColor(hex: "#6d4f31"))
                            .background(
                                            LinearGradient(gradient: Gradient(colors: [hexToColor(hex: "#f9e3c6"), hexToColor(hex: "#d1b18b")]), startPoint: .leading, endPoint: .trailing)
                                        )
                            .background(hexToColor(hex: "#d9bb98"))
                            .cornerRadius(12)
                    } else {
                        NavigationLink(destination: ProSwiftUIView()) {
                            Text("购买升级版")
                        }
                    }
                    
                    Button(action: {
                        Task {
                            try? await AppStore.sync()
                        }
                    }) {
                        Text("恢复购买")
                    }
                  
//                    
//                    Button("Send Email") {
//                        self.isShowingMailView.toggle()
//                    }
//                    .sheet(isPresented: $isShowingMailView) {
//                        MailView(isShowing: self.$isShowingMailView)
//                    }
                }
                
                Section(header: Text("设置")) {
                    HStack {
                        NavigationLink(destination: AppIconView()) {
                            Text("更改 App  图标")
                        }
                    }
                    //                    NavigationLink(destination: ProSwiftUIView()) {
                    //                        Text("翻页声音")
                    //                    }
//                    NavigationLink(destination: ProSwiftUIView()) {
//                        Text("在状态栏和锁屏中显示")
//                    }
//                    NavigationLink(destination: ProSwiftUIView()) {
//                        Text("在待机模式时显示")
//                    }
                    NavigationLink(destination: ChargeView()) {
                        Text("充电时自动运行")
                    }
                    
                }
                
                Section(header: Text("用户反馈和关于")) {
//                    NavigationLink(destination: FeedbackView()) {
//                        Text("好评")
//                    }
                    
              
                    Button(action: {
                        if let url = URL(string: "itms-apps://itunes.apple.com/app/6502540017?action=write-review"),

                           UIApplication.shared.canOpenURL(url){

                            UIApplication.shared.open(url, options: [:], completionHandler: nil)

                        }
                        // ios有时候无法吊起来
//                       requestReview()


                    }) {
                        Text("好评")
                      
                    }
           
//                    Text("建议吐槽")
                    sendMailSwiftUIView()
//                    NavigationLink(destination: AboutUsView()) {
//                        Text("关于我们")
//                    }
                    
                    Text("当前版本(v1.0.7) ")
                }
                
                
//                Section(header: Text("其他")) {
//                 
//                    
//                    
//                    
//                }
                
                Section(header: Text("分享")) {
                    Button(action: {
                        // 分享给朋友的操作
        
                        self.isShowingActivityView = true
                        
                        // 分享给朋友的操作
//                        if let scene = UIApplication.shared.connectedScenes.first as ? UIWindowScene {
//                                        SKStoreReviewController.requestReview(in: scene)
//                                    }
                    }) {
                        Text("分享给朋友")
                    }   .sheet(isPresented: $isShowingActivityView, content: {
                        ActivityViewController(activityItems: [self.getAppShareText(), self.getAppStoreLink()])
//                        ActivityViewController(activityItems: [self.getAppStoreLink()])
                    })
                    
//                    Button("Share") {
//                              
//                            }
                          
                    
                }
                
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("设置")
//        }
    }
}

struct FeedbackView: View {
    var body: some View {
        //        Content1View()
        Text("这是用户反馈页面")
            .navigationTitle("用户反馈")
    }
}

struct ChargeView: View {
    var body: some View {
        VStack{
            HStack(alignment: .top){
                Image(systemName:"1.circle.fill")
                    .resizable()
                    .frame(width: 22, height:22) // 设置图片大小
                    .foregroundColor(.blue)
                Text("打开「快捷指令」，「选择自动化」，点击 「创建个人自动化」")
                Spacer()
            }
            HStack(alignment: .top){
                Image(systemName:"2.circle.fill")
                    .resizable()
                    .frame(width: 22, height:22) // 设置图片大小
                    .foregroundColor(.blue)
                Text("选择「充电器」，点击下一步")
                Spacer()
            }
           
            HStack(alignment: .top){
                Image(systemName:"3.circle.fill")
                    .resizable()
                    .frame(width: 22, height:20) // 设置图片大小
                    .foregroundColor(.blue)
                Text("点击「添加操作」，「选择脚本」，搜索并添加「打开App」，点击「选择」，搜索并选择「表盘时钟」吗，点击下一步")
                Spacer()
            }
           
            HStack(alignment: .top){
                Image(systemName:"4.circle.fill")
                    .resizable()
                    .frame(width: 22, height:22) // 设置图片大小
                    .foregroundColor(.blue)
            Text("关闭「运行前询问」，点击完成")
                Spacer()
            }
           
            
           Spacer()
            
        }.padding(30).font(.system(size: 18))
            .navigationTitle("充电时自动运行")
    }
}

struct AboutUsView: View {
    var body: some View {
        
        VStack{
        
            Text("")
        }.navigationTitle("关于我们")
    }
}

#Preview {
    SettingSwiftUIView()
}



struct AppIconView: View {
    @Environment(\.colorScheme) var colorScheme
    // 存储所有可选的图片名称
    let imageNames:[Int] = [1, 2, 3, 4, 5, 6, 7, 8] // 添加你的图片名称
    let imageNames1 = ["AppIcon1", "AppIcon2", "AppIcon3", "AppIcon4",
                       "AppIcon5", "AppIcon6", "AppIcon7", "AppIcon8",
    ] // 添加你的图片名称
    let imageNames2 = ["Minimalist Bright", "Low Profile Luxury", "Minimalist Dark Gray", "Minimalist Light Grey",
                       "RomanNumerals", "RomanNumerals-1", "Minimalist Black", "Memphis Default",
    ]
//    let imageNames3 = ["极简明亮", "低调的奢华", "极简深灰", "极简浅灰",
//                       "罗马数字", "罗马数字-1", "极简黑", "孟菲斯-默认",
//    ]
    let imageNames3 = ["1", "2", "3", "4",
                       "5", "6", "7", "8",
    ]
    // 添加你的图片名称
    
    //    bright，Low-Profile Luxury，Minimalist light gray，Minimalist Dark Grey
    @State private var selectedImage: Int?
    // 绑定用于存储当前选定的图片名称的集合
    @State private var selectedImages: Set<String> = []
  
    @AppStorage("setting_active_app_icon") var setting_active_app_icon = ""
    var body: some View {
        VStack {
            
            // List 中显示图片
            List {
                ForEach(imageNames, id: \.self) { imageName in
                    Button(action: {
                        self.selectedImage = imageName
                        UIApplication.shared.setAlternateIconName(imageNames1[imageName - 1 ]) { (error) in
                            if let error = error {
                                print("Failed request to update the app’s icon: \(error)")
                            }
                        }
                    }) {
                        HStack {
                            Image(String(imageName))
                                .resizable()
                                .frame(width: 50, height: 50) // 设置图片大小
                                .cornerRadius(10)
                            Text(imageNames3[imageName - 1 ])
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            if imageName == self.selectedImage {Image(systemName: "checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:20, height: 20)
                                    .foregroundColor(.blue)
                                
                                    .padding()
                            }
                        }
                    }
                }
            }
            
            
        }
    }
}


// UIViewControllerRepresentable 的 SwiftUI 封装
//struct MailView: UIViewControllerRepresentable {
//    @Binding var isShowing: Bool // 控制邮件发送视图的显示状态
//
//    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
//        @Binding var isShowing: Bool // 绑定到视图状态
//
//        init(isShowing: Binding<Bool>) {
//            self._isShowing = isShowing
//        }
//
//        func mailComposeController(
//            _ controller: MFMailComposeViewController,
//            didFinishWith result: MFMailComposeResult,
//            error: Error?
//        ) {
//            controller.dismiss(animated: true)
//            isShowing = false // 关闭邮件发送视图
//        }
//    }

    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(isShowing: $isShowing) // 返回一个协调器实例
//    }
//
//    func makeUIViewController(context: Context) -> MFMailComposeViewController {
//        let vc = MFMailComposeViewController()
//        vc.mailComposeDelegate = context.coordinator // 关联协调器
//        vc.setSubject("默认主题") // 设置默认主题
//        vc.setMessageBody("默认邮件内容的末尾文字", isHTML: false) // 设置默认内容
//        return vc
//    }
//
//    func updateUIViewController(
//        _ uiViewController: MFMailComposeViewController,
//        context: Context
//    ) {
//        // 在需要时更新 UIViewController
//    }
//}



struct ActivityViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Do nothing
    }
}
