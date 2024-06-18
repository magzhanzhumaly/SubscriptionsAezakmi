import ApphudSDK
import Combine
import SwiftUI
import StoreKit

class IAPManager: ObservableObject {
    static let shared = IAPManager()
    
    @Published var products: [ApphudProduct] = []
    
    private init() {
        Task {
            await self.fetchProducts()
        }
    }
    
    @MainActor
    func fetchProducts() {
        Apphud.fetchPlacements { placements, error in
            if let error = error {
                print("Error fetching placements: \(error.localizedDescription)")
            } else if let placement = placements.first(where: { $0.identifier == "" }), let paywall = placement.paywall  {
                // TODO: вставить placement id
                let products = paywall.products
                self.products = products
                
                Apphud.paywallShown(paywall)
            } else {
                print("No placements or products available")
            }
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
