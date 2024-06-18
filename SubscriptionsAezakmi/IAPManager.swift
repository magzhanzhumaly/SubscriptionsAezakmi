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
    //    func fetchProducts() {
    //        Apphud.fetchPlacements { placements, error in
    //            if let error = error {
    //                print("Error fetching placements: \(error.localizedDescription)")
    //            } else if let placement = placements.first(where: { $0.identifier == "" }), let paywall = placement.paywall  {
    //                // TODO: вставить placement id
    //                let products = paywall.products
    //                self.products = products
    //
    //                Apphud.paywallShown(paywall)
    //            } else {
    //                print("No placements or products available")
    //            }
    //        }
    //    }
    func fetchProducts(_ type: PaywallType) async throws {
        print("res1")
        guard let paywall = await Apphud.paywall(type.rawValue) else { throw PaywallError.noPaywall }
        for product in paywall.products {
            DispatchQueue.main.async {
                self.products.append(product)
            }
        }
        DispatchQueue.main.async {
            self.selectedProduct = self.products.first
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
