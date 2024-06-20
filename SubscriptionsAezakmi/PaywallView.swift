import SwiftUI
import ApphudSDK

struct PaywallView: View {
    @State private var paywall: ApphudPaywall?
    @State private var products: [ApphudProduct] = []
    @State private var error: String?
    
    var body: some View {
        VStack {
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
            } else if let paywall = paywall {
                List(products, id: \.productId) { product in
                    Button(action: {
                        purchaseProduct(product)
                    }) {
                        Text(product.name ?? "")
                    }
                }
            } else {
                ProgressView("Loading paywall...")
            }
        }
        .onAppear {
            Task {
                await fetchPaywall()
            }
        }
    }
    
    private func fetchPaywall() async {
        
        guard let paywall = await Apphud.paywall("subscriptions_paywall") else {
            print("No paywall found with identifier: subscriptions_paywall")
            //            throw PaywallError.noPaywall
            return
        }
        
        //        print("Paywall found: \(paywall)")
        //
        //        for product in paywall.products {
        //            print("Adding product: \(product.productId)")
        //            DispatchQueue.main.async {
        //                self.products.append(product)
        //            }
        //        }
        //
        //        DispatchQueue.main.async {
        //            self.selectedProduct = self.products.first
        //            print("Selected product: \(String(describing: self.selectedProduct?.productId))")
        //        }
        //    }
        //
        //
        //        await Apphud.paywall("subscriptions_paywall") //{ paywall in
        //        if let paywall = paywall {
        self.paywall = paywall
        self.products = paywall.products
        print("paywall.products = \(paywall.products)")
        //        } else {
        //            self.error = "Failed to load paywall."
        //        }
        //        }
    }
    
    @MainActor private func purchaseProduct(_ product: ApphudProduct) {
        Apphud.purchase(product) { result in
            if result.success {
                // Handle successful purchase
                print("Purchase successful!")
            } else {
                self.error = "Purchase failed: \(result.error?.localizedDescription ?? "Unknown error")"
            }
        }
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
    }
}

//
//
//import SwiftUI
//import ApphudSDK
//struct PaywallView: View {
//    @State private var paywall: ApphudPaywall?
//    @State private var products: [ApphudProduct] = []
//    @State private var error: String?
//
//    var body: some View {
//        VStack {
//            if let error = error {
//                Text(error)
//                    .foregroundColor(.red)
//            } else if let paywall = paywall {
//                List(products, id: \.productId) { product in
//                    Button(action: {
//                        purchaseProduct(product)
//                    }) {
//                        Text(product.name ?? "")
//                    }
//                }
//            } else {
//                ProgressView("Loading paywall...")
//            }
//        }
//        .onAppear {
//            Task {
//               await fetchPaywall()
//            }
//        }
//    }
//
//    private func fetchPaywall() async {
//        await Apphud.paywall("subscriptions_paywall")
//            if let paywall = paywall {
//                self.paywall = paywall
//                self.products = paywall.products
//            } else {
//                self.error = "Failed to load paywall."
//            }
//        }
//
//
//    @MainActor private func purchaseProduct(_ product: ApphudProduct) {
//        Apphud.purchase(product) { result in
//            if result.success {
//                // Handle successful purchase
//            } else {
//                self.error = "Purchase failed: \(result.error?.localizedDescription ?? "Unknown error")"
//            }
//        }
//    }
//}
//
//struct PaywallView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaywallView()
//    }
//}
//
