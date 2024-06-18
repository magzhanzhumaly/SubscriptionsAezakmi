//
//  SubscriptionsAezakmiApp.swift
//  SubscriptionsAezakmi
//
//  Created by Magzhan Zhumaly on 17.06.2024.
//

import SwiftUI
import StoreKit
import ApphudSDK

@main
struct SubscriptionsAezakmiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .onAppear {
//                    IAPManager.shared.fetchProducts()
//                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Apphud.start(apiKey: "app_ndGknYk3TcfJ5cA3ig55R42RW1D6un")

        return true
    }

//    func applicationWillTerminate(_ application: UIApplication) {
//        SKPaymentQueue.default().remove(IAPManager.shared)
//    }
}

