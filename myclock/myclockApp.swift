//
//  myclockApp.swift
//  myclock
//
//  Created by  玉城 on 2024/4/22.
//

import SwiftUI
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("app delegate")
        return true
    }
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return .all
//    }
//
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app did enter background")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("app will terminate")
    }
    
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}


@main
struct myclockApp: App {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var modelData = ModelData()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
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
    
    var body: some Scene {
        WindowGroup {
            //   Text("Hello, \(UserDefaults.standard.string(forKey: "textColor") ?? "")!")
            let textColor: String = UserDefaults.standard.string(forKey: "textColor") ?? ""
            let backgroundColor: String = UserDefaults.standard.string(forKey: "backgroundColor") ?? ""
            let bgSecondColor: String = UserDefaults.standard.string(forKey: "bgSecondColor") ?? ""
            // https://stackoverflow.com/questions/66435806/how-to-share-data-between-main-app-and-widgets widget 通信
            ContentView().environment(modelData).environmentObject(ThemeManager(
                themeTextColor: textColor.isEmpty ? .white : hexToColor(hex:textColor),
                themeBackgroundColor: backgroundColor.isEmpty ? .black :  hexToColor(hex:backgroundColor),
                themeBgSecondColor: bgSecondColor.isEmpty ? Color.customBlack :  hexToColor(hex:bgSecondColor)
            ))
           .statusBar(hidden: true)
        }
        .modelContainer(sharedModelContainer)
    }
}


extension Color {
    static let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    static let customRed = Color(red: 0.8902, green: 0.5059, blue: 0.6471)
    static let customBlack = Color(red: 28/255, green: 28/255, blue: 29/255)
    static let customLightRed = Color(red: 0.96, green: 0.92, blue: 0.95)
}


class ThemeManager: ObservableObject {
    @Published var themeTextColor: Color
    @Published var themeBackgroundColor: Color
    @Published var themeBgSecondColor: Color
    
    
    init(themeTextColor : Color, themeBackgroundColor: Color,themeBgSecondColor: Color) {
        self.themeTextColor = themeTextColor
        self.themeBackgroundColor = themeBackgroundColor
        self.themeBgSecondColor = themeBgSecondColor
    }
}
 
