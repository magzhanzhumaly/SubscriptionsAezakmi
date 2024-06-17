//
//  ContentView.swift
//  SubscriptionsAezakmi
//
//  Created by Magzhan Zhumaly on 17.06.2024.
//

import StoreKit
import SwiftUI

struct ContentView: View {
    @ObservedObject var iapManager = IAPManager.shared
    @State private var selectedOption: String? = nil
    
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
                    if let product = iapManager.products.first(where: { $0.productIdentifier == selectedOption }) {
                        iapManager.buyProduct(product)
                    }
                }) {
                    Text("Try free & subscribe")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                        .cornerRadius(10)
                }
                .padding()
                
                HStack {
                    Button(action: {
                        // TODO: добавить terms of use
                    }) {
                        Text("Terms of Use")
                            .foregroundStyle(.accent)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // TODO: добавить privacy policy
                    }) {
                        Text("Privacy Policy")
                            .foregroundStyle(.accent)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        SKPaymentQueue.default().restoreCompletedTransactions()
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
    }
    
    private func subscriptionOption(title: String, period: String, price: String, fullPrice: String, productID: String) -> some View {
        VStack {
            Text(title)
                .font(.caption)
//                .padding(.top, 10)
//                .padding(.bottom, 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.accent)
                .foregroundColor(.white)
                .frame(height: 45)
                .multilineTextAlignment(.center)

//            Spacer()
            
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
//            if let product = iapManager.products.first(where: { $0.productIdentifier == productID }) {
//                iapManager.buyProduct(product)
//            }
        }
    }
}

extension Color {
    static let accentLight = Color.accentColor.opacity(0.1)
}

#Preview {
    ContentView()
}
