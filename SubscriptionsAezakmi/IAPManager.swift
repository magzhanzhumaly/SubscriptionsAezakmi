import ApphudSDK
import Combine
import SwiftUI
import StoreKit

class IAPManager: ObservableObject {
    static let shared = IAPManager()
    
    @Published var products: [ApphudProduct] = []
    @Published var selectedProduct: ApphudProduct?
    
    private init() {
        Task {
            try await self.fetchProducts(.paywall)
        }
    }

    @MainActor
    func fetchProducts(_ type: PaywallType) async throws {
        print("Fetching products for paywall type: \(type.rawValue)")
        
        guard let paywall = await Apphud.paywall(type.rawValue) else {
            print("No paywall found with identifier: \(type.rawValue)")
            throw PaywallError.noPaywall
        }
        
        print("Paywall found: \(paywall)")
        
        for product in paywall.products {
            print("Adding product: \(product.productId)")
            DispatchQueue.main.async {
                self.products.append(product)
            }
        }
        
        DispatchQueue.main.async {
            self.selectedProduct = self.products.first
            print("Selected product: \(String(describing: self.selectedProduct))")
        }
    }


    @MainActor func buyProduct(_ product: ApphudProduct) {
        Apphud.purchase(product) { result in
            if let subscription = result.subscription, subscription.isActive(){
                print("Subscription purchased: \(subscription.productId)")
            } else if let purchase = result.nonRenewingPurchase, purchase.isActive(){
                print("Non-renewing purchase: \(purchase.productId)")
            } else {
                print("Purchase cancelled")
            }
        }
    }
}

enum PaywallType: String {
    case paywall = "subscriptions_paywall"
    //    case noPaywall = "no_paywall"
}

enum PaywallError: Error {
    case noPaywall
}
