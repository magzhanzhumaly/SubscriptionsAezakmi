//
//  SubscriptionsAezakmiApp.swift
//  SubscriptionsAezakmi
//
//  Created by Magzhan Zhumaly on 17.06.2024.
//

import SwiftUI
import StoreKit

@main
struct SubscriptionsAezakmiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    IAPManager.shared.fetchProducts()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        Apphud.start(apiKey: "") //TODO: вставить ключ

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(IAPManager.shared)
    }
}

