////
////  ContentViewFileOld.swift
////  SubscriptionsAezakmi
////
////  Created by Magzhan Zhumaly on 17.06.2024.
////
//
//import SwiftUI
//
//struct ContentViewOld: View {
//    @ObservedObject var iapManager = IAPManager.shared
//
//    var body: some View {
//        VStack {
//            Text("Unlimited access!")
//                .font(.largeTitle)
//                .padding(.top)
//            
//            Text("Try 3 days free then $4.99/week")
//                .font(.subheadline)
//                .padding(.bottom)
//
//            HStack(spacing: 10) {
//                subscriptionOption(title: "POPULAR", period: "MONTHLY", price: "$3.99 per week", fullPrice: "$15.99/month", productID: "com.example.app.monthly")
//                
//                subscriptionOption(title: "3 DAYS FREE TRIAL", period: "WEEKLY", price: "$4.99 per week", fullPrice: "$4.99/week", productID: "com.example.app.weekly")
//                    .background(Color.blue.opacity(0.1))
//                    .cornerRadius(10)
//
//                subscriptionOption(title: "BEST DEAL", period: "YEARLY", price: "$0.79 per week", fullPrice: "$39.99/year", productID: "com.example.app.yearly")
//            }
//            .padding()
//
//            Button(action: {
//                // Add action for subscribe button
//            }) {
//                Text("Try free & subscribe")
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding()
//
//            HStack {
//                Button(action: {
//                    // Add action for terms of use
//                }) {
//                    Text("Terms of Use")
//                }
//
//                Spacer()
//
//                Button(action: {
//                    // Add action for privacy policy
//                }) {
//                    Text("Privacy Policy")
//                }
//
//                Spacer()
//
//                Button(action: {
//                    Apphud.restorePurchases { subscriptions, purchases, error in
//                        if let error = error {
//                            print("Restore error: \(error.localizedDescription)")
//                        } else {
//                            print("Purchases restored")
//                        }
//                    }
//                }) {
//                    Text("Restore")
//                }
//            }
//            .padding(.horizontal)
//            .font(.footnote)
//        }
//        .padding()
//        .onAppear {
//            iapManager.fetchProducts()
//        }
//    }
//
//    private func subscriptionOption(title: String, period: String, price: String, fullPrice: String, productID: String) -> some View {
//        VStack {
//            Text(title)
//                .font(.caption)
//                .padding(.top, 10)
//                .padding(.bottom, 2)
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .foregroundColor(.white)
//
//            Text(period)
//                .font(.headline)
//                .padding(.top, 10)
//
//            Text(price)
//                .font(.subheadline)
//                .padding(.bottom, 5)
//
//            Text(fullPrice)
//                .font(.caption)
//                .foregroundColor(.gray)
//                .padding(.bottom, 10)
//        }
//        .frame(maxWidth: .infinity) // Ensures equal width for all options
//        .border(Color.gray, width: 1)
//        .cornerRadius(10)
//        .onTapGesture {
//            if let product = iapManager.products.first(where: { $0.productId == productID }) {
//                iapManager.buyProduct(product)
//            }
//        }
//    }
//}
