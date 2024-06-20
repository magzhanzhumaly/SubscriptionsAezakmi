import ApphudSDK
import Combine
import SwiftUI
import StoreKit

typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

class IAPManager: ObservableObject {
    static let shared = IAPManager()
    
    @Published private(set) var subscriptions: [Product] = []
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    private let productIds:
    [String] = ["com.magzhanzhumaly.SubscriptionsAezakmi.weekly",
                "com.magzhanzhumaly.SubscriptionsAezakmi.monthly",
                "com.magzhanzhumaly.SubscriptionsAezakmi.yearly"]
    
    @Published var products: [ApphudProduct] = []
    @Published var selectedProduct: ApphudProduct?
    
    private init() {
        Task {
            try await self.fetchProducts(.paywall)
        }
    }

    func displayPaywall(_ paywall: ApphudPaywall) {
            // Display the paywall's products
            for product in paywall.products {
                // Create UI elements for each product and add them to your view
                // For example, you can create buttons or labels for each product
                let productButton = UIButton()
                productButton.setTitle(product.name, for: .normal)
//                productButton.addTarget(self, action: #selector(self.purchaseProduct(_:)), for: .touchUpInside)
//                productButton.tag = product.productId.hashValue
//                self.view.addSubview(productButton)
            }
        }

    @MainActor
    func fetchProducts(_ type: PaywallType) async throws {
//        Apphud.paywall("subscriptions_paywall") { paywall in
//            guard let paywall = paywall else {
//                // Handle the error if the paywall is not fetched
//                return
//            }
//            
//            // Display the paywall
//            self.displayPaywall(paywall)
//        }

//        do {
//            subscriptions = try await Product.products(for: productIds)
//            print (subscriptions)
//        } catch {
//            print("Failed product request from app store server: \(error)")
//        }
        
        
        
        
//        do {
//            let result = try await Apphud.fetchProducts()
//            print(result)
//            for product in result. {
//                print("Adding product: \(product.productId)")
//                DispatchQueue.main.async {
//                    self.products.append(product)
//                }
//            }
//            
//            DispatchQueue.main.async {
//                self.selectedProduct = self.products.first
//                print("Selected product: \(String(describing: self.selectedProduct?.productId))")
//            }
//        } catch {
//            print(error)
//        }
//        print("Fetching products for paywall type: \(type.rawValue)")
        
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
            print("Selected product: \(String(describing: self.selectedProduct?.productId))")
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
