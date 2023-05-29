//
//  ProPresenter.swift
//  
//
//  Created by Rafael Santos on 28/03/23.
//

import SwiftUI
//import StoreKit
import Domain
import Data
import Resource

@MainActor
public protocol ProPresenterProtocol: ObservableObject {
    var isAcceptedTerms: Bool { get set }
    var acceptedAlert: AlertItem { get set }
    //var products: [Product] { get set }
    var purchasedProductIDs: Set<String> { get set }
    
    func string(_ string: Strings.Pro) -> String
    func buyPro() async throws
    func restore() async throws
}

@MainActor
public final class ProPresenter: NSObject, ProPresenterProtocol {
    public static let shared = ProPresenter()
    @Published public var isAcceptedTerms: Bool = false
    @Published public var acceptedAlert: AlertItem = .init()
    //@Published public var products: [Product] = []
    @Published public var purchasedProductIDs = Set<String>()
    private var updates: Task<Void, Never>? = nil
    private let productIds = ["budget.subscription.pro.monthly"]
    
    private override init() {
        super.init()
        Task {
            try? await loadProducts()
            await updatePurchasedProducts()
            updates = observeTransactionUpdates()
        }
    }
    
    deinit { updates?.cancel() }
    
    public func string(_ string: Strings.Pro) -> String {
        string.value
    }
    
    @MainActor private func loadProducts() async throws {
        //self.products = try await Product.products(for: productIds)
    }
    
    @MainActor public func buyPro() async throws {
//        guard isAcceptedTerms else {
//            acceptedAlert = .init(error: .dontAcceptedTerms)
//            return
//        }
//
//        guard let product = products.first else {
//            acceptedAlert = .init(error: .notFoundProducts)
//            return
//        }
//
//        try await purchase(product)
    }
    
    @MainActor public func restore() async throws {
        //try await AppStore.sync()
        await updatePurchasedProducts()
    }
    
//    @MainActor private func purchase(_ product: Product) async throws {
//        let result = try await product.purchase()
//        switch result {
//        case let .success(.verified(transaction)): await transaction.finish()
//        case let .success(.unverified(_, error)): throw error
//        case .pending: break
//        case .userCancelled: break
//        default: break
//        }
//        await updatePurchasedProducts()
//    }
    
    @MainActor public func updatePurchasedProducts() async {
//        for await result in Transaction.currentEntitlements {
//            guard case .verified(let transaction) = result else { continue }
//            if transaction.revocationDate == nil {
//                self.purchasedProductIDs.insert(transaction.productID)
//            } else {
//                self.purchasedProductIDs.remove(transaction.productID)
//            }
//        }
//        try? Worker.shared.settings.add(isPro: !self.purchasedProductIDs.isEmpty)
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { //[unowned self] in
//            for await _ in Transaction.updates {
//                await self.updatePurchasedProducts()
//            }
        }
    }
}
