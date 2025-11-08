//
//  SubscriptionView.swift
//  IAP_Subscription
//
//  Created by Sairam G on 12/10/25.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @State private var products: [Product] = []
    @State private var purchaseState: String = "Loading products..."
    
    let productIDs = ["com.sairam.IAPSubscription.Monthly"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🪄 Available Subscriptions")
                .font(.title)
                .bold()
            
            if products.isEmpty {
                ProgressView()
                    .onAppear { fetchProducts() }
            } else {
                ForEach(products) { product in
                    VStack {
                        Text(product.displayName)
                            .font(.headline)
                        Text(product.displayPrice)
                            .font(.subheadline)
                        Button("Subscribe") {
                            Task { await purchase(product) }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            
            Text(purchaseState)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    // MARK: - StoreKit
    
    func fetchProducts() {
        Task {
            do {
                products = try await Product.products(for: productIDs)
                purchaseState = "Loaded \(products.count) product(s)"
            } catch {
                purchaseState = "Failed to load products: \(error.localizedDescription)"
            }
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    purchaseState = "✅ Purchased \(transaction.productID)"
                    await transaction.finish()
                } else {
                    purchaseState = "⚠️ Transaction unverified"
                }
            case .userCancelled:
                purchaseState = "Purchase cancelled"
            case .pending:
                purchaseState = "Purchase pending..."
            @unknown default:
                purchaseState = "Unknown purchase result"
            }
        } catch {
            purchaseState = "❌ Purchase failed: \(error.localizedDescription)"
        }
    }
}

