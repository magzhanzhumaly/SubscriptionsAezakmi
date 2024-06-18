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


struct ContentView: View {
    @ObservedObject var iapManager = IAPManager.shared
    @State private var selectedOption: String? = nil
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfUse = false
    @State private var buttonTitle = "Try free & subscribe"
  
    init() {
        iapManager.fetchProducts()
    }
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Unlimited access!")
                    .font(.largeTitle)
                    .padding(.top)
                    .foregroundStyle(.black)
                
                Text("Try 3 days free then $4.99/week")
                    .font(.subheadline)
                    .padding(.bottom)
                    .foregroundColor(.black)
                
                HStack(spacing: 10) {
                    subscriptionOption(title: "POPULAR",
                                       period: "MONTHLY",
                                       price: "$3.99 per week",
                                       fullPrice: "$15.99/month",
                                       productID: "com.magzhanzhumaly.SubscriptionsAezakmi.monthly")
                    
                    subscriptionOption(title: "3 DAYS FREE TRIAL",
                                       period: "WEEKLY",
                                       price: "$4.99 per week",
                                       fullPrice: "$4.99/week",
                                       productID: "com.magzhanzhumaly.SubscriptionsAezakmi.weekly")
                    
                    subscriptionOption(title: "BEST DEAL",
                                       period: "YEARLY",
                                       price: "$0.79 per week",
                                       fullPrice: "$39.99/year",
                                       productID: "com.magzhanzhumaly.SubscriptionsAezakmi.yearly")
                }
                .padding()
                
                Button(action: {
                    if let product = iapManager.products.first(where: { $0.productId == selectedOption }) {
                    }
                }) {
                    Text(buttonTitle)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                        .cornerRadius(10)
                }
                .padding()
                
                HStack {
                    Button(action: {
                        showTermsOfUse = true
                    }) {
                        Text("Terms of Use")
                            .foregroundStyle(.accent)
                    }
                    
                    Spacer()
                    
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
            .background(Color.white)
            .padding()
        }
        .onAppear {
            iapManager.fetchProducts()

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
            buttonTitle = selectedOption == "com.magzhanzhumaly.SubscriptionsAezakmi.weekly" ? "Try free & subscribe" : "Subscribe"
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
