//
//  CratedigApp.swift
//  Cratedig
//
//  Created by Noah Boyers on 4/4/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CratedigApp: App {
    init() {
               for family in UIFont.familyNames.sorted() {
                   let names = UIFont.fontNames(forFamilyName: family)
                   print("Family: \(family) Font names: \(names)")
               }
           }
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
