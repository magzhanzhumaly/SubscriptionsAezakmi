//
//  ContentView.swift
//  SubscriptionsAezakmi
//
//  Created by Magzhan Zhumaly on 17.06.2024.
//

import StoreKit
import SwiftUI
import ApphudSDK
import Combine
import WebKit

struct ProductPrice {
    let weeklyPrice: Double
    let periodPrice: Double
}

enum ProductID: String {
    case weekly = "com.magzhanzhumaly.SubscriptionsAezakmi.weekly"
    case monthly = "com.magzhanzhumaly.SubscriptionsAezakmi.monthly"
    case yearly = "com.magzhanzhumaly.SubscriptionsAezakmi.yearly"
    
    static var allCases: [ProductID] {
        return [.weekly, .monthly, .yearly]
    }
}

struct ContentView: View {
    @ObservedObject var iapManager = IAPManager.shared
    @State private var selectedOption: String? = nil
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfUse = false
    @State private var subscriptionButtonTitle = "Try free & subscribe"
    @State private var subtitle = "Try 3 days free then $4.99/week"
    
    let weeklySubscriptionPrice = ProductPrice(weeklyPrice: 4.99, periodPrice: 4.99)
    let monthlySubscriptionPrice = ProductPrice(weeklyPrice: 3.99, periodPrice: 15.99)
    let yearlySubscriptionPrice = ProductPrice(weeklyPrice: 0.79, periodPrice: 39.99)
    
    
    init() {
        // Call fetchProducts here if needed during initialization
        //        Task {
        ////            guard let self = self else { return }
        //            do {
        //                try await self.iapManager.fetchProducts(.paywall)
        //            } catch {
        //                // Handle the error here (e.g., log it, show an alert to the user)
        //                print("Error fetching products: \(error.localizedDescription)")
        //            }
        //        }
    }
    
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Unlimited access!")
                    .font(.largeTitle)
                    .padding(.top)
                    .foregroundStyle(.black)
                
                Text(subtitle)
                    .font(.subheadline)
                    .padding(.bottom)
                    .foregroundColor(.black)
                
                HStack(spacing: 10) {
                    subscriptionOption(title: "POPULAR",
                                       period: "MONTHLY",
                                       price: "$\(weeklySubscriptionPrice.weeklyPrice) per week",
                                       fullPrice: "$\(weeklySubscriptionPrice.periodPrice)/month",
                                       productID: ProductID.monthly.rawValue)
                    
                    subscriptionOption(title: "3 DAYS FREE TRIAL",
                                       period: "WEEKLY",
                                       price: "$\(monthlySubscriptionPrice.weeklyPrice) per week",
                                       fullPrice: "$\(monthlySubscriptionPrice.periodPrice)/week",
                                       productID: ProductID.weekly.rawValue)
                    
                    subscriptionOption(title: "BEST DEAL",
                                       period: "YEARLY",
                                       price: "$\(yearlySubscriptionPrice.weeklyPrice) per week",
                                       fullPrice: "$\(yearlySubscriptionPrice.periodPrice)/year",
                                       productID: ProductID.yearly.rawValue)
                }
                .padding()
                
                Button(action: {
                    print(selectedOption)

                    if let product = iapManager.products.first(where: { $0.productId == selectedOption }) {
                        iapManager.buyProduct(product)
                    }
                }) {
                    Text(subscriptionButtonTitle)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                        .cornerRadius(10)
                }
                .padding()
                
                ZStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showPrivacyPolicy = true
                        }) {
                            Text("Privacy Policy")
                                .foregroundStyle(.accent)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .font(.footnote)
                    
                    
                    
                    HStack {
                        Button(action: {
                            showTermsOfUse = true
                        }) {
                            Text("Terms of Use")
                                .foregroundStyle(.accent)
                        }
                        
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await Apphud.restorePurchases()
                                
                            }
                            
                        }) {
                            Text("Restore")
                                .foregroundStyle(.accent)
                        }
                    }
                    .padding(.horizontal)
                    .font(.footnote)
                }
            }
            .background(Color.white)
            .padding()
        }
        .onAppear {
            Task {
                do {
                    try await iapManager.fetchProducts(.paywall)
                    print(iapManager.products)
                } catch {
                    print("Error fetching products: \(error.localizedDescription)")
                }
            }
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            WebView(url: URL(string: "https://www.termsfeed.com/live/e5fd68c8-2953-4738-a90b-b66f0f1f1c69")!)
        }
        .sheet(isPresented: $showTermsOfUse) {
            WebView(url: URL(string: "https://www.termsfeed.com/live/e5fd68c8-2953-4738-a90b-b66f0f1f1c69")!)
        }
    }
    
    
    
    
    
    private func subscriptionOption(title: String, period: String, price: String, fullPrice: String, productID: String) -> some View {
        VStack {
            Text(title)
                .font(.caption)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.accent)
                .foregroundColor(.white)
                .frame(height: 45)
                .multilineTextAlignment(.center)
            
            Text(period)
                .font(.headline)
                .padding(.top, 10)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            
            Text(price)
                .font(.subheadline)
                .padding(.bottom, 5)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Text(fullPrice)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
                .multilineTextAlignment(.center)
            
        }
        .background(selectedOption == productID ? Color.accentLight : Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .onTapGesture {
            selectedOption = productID
            
            if selectedOption == ProductID.weekly.rawValue {
                subscriptionButtonTitle = "Try free & subscribe"
                subtitle = "Try 3 days free then $\(weeklySubscriptionPrice.weeklyPrice) per week"
            } else{
                subscriptionButtonTitle = "Subscribe"
                if selectedOption == ProductID.weekly.rawValue {
                    subtitle = "$\(monthlySubscriptionPrice.weeklyPrice) per week"
                } else { // yearly
                    subtitle = "$\(yearlySubscriptionPrice.weeklyPrice) per week"
                }
            }
        }
    }
}

extension Color {
    static let accentLight = Color.accentColor.opacity(0.2)
}

#Preview {
    ContentView()
}


struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
