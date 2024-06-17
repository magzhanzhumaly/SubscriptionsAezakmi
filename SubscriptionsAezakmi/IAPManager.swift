//
//  IAPManager.swift
//  SubscriptionsAezakmi
//
//  Created by Magzhan Zhumaly on 17.06.2024.
//

import StoreKit

class IAPManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()

    @Published var products: [SKProduct] = []
    @Published var purchasedProductIDs: Set<String> = []

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    func fetchProducts() {
//        async {
//            do {
//                let products = try await Product.request(with: ["com.magzhanzhumaly.SubscriptionsAezakmi.weekly",
//                                                                "com.magzhanzhumaly.SubscriptionsAezakmi.monthly",
//                                                                "com.magzhanzhumaly.SubscriptionsAezakmi.yearly"])
//            } catch {
//                
//            }
//        }
        let productIdentifiers = Set(["com.magzhanzhumaly.SubscriptionsAezakmi.weekly",
                                      "com.magzhanzhumaly.SubscriptionsAezakmi.monthly",
                                      "com.magzhanzhumaly.SubscriptionsAezakmi.yearly"])
        
        
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
//        products = request

        request.delegate = self
        request.start()
    }
    
//    func purchase(product: Product) {
//        do {
//            let result = try await product.purchase()
//        } catch {
//            
//        }
//    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }

    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                DispatchQueue.main.async {
                    self.purchasedProductIDs.insert(transaction.payment.productIdentifier)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let error = transaction.error as? SKError {
                    print("Transaction failed with error: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                DispatchQueue.main.async {
                    self.purchasedProductIDs.insert(transaction.payment.productIdentifier)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }
}
