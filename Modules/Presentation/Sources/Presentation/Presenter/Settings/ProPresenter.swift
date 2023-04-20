//
//  ProPresenter.swift
//  
//
//  Created by Rafael Santos on 28/03/23.
//

import SwiftUI
import StoreKit
import Domain
import Resource

public protocol ProPresenterProtocol: ObservableObject {
    var isAcceptedTerms: Bool { get set }
    var acceptedAlert: AlertItem { get set }
    
    func string(_ string: Strings.Pro) -> String
    func buyPro(onSuccess: (() -> Void)?, onError: ((BudgetError) -> Void)?)
}

public final class ProPresenter: NSObject, ProPresenterProtocol {
    @Published public var isAcceptedTerms: Bool = false
    @Published public var acceptedAlert: AlertItem = .init()
    private let mothlySubscriptionID = "budget.subscription.monthly.pro"
    private var products: [String: SKProduct] = [:]
    
    public override init() {}
    
    public func string(_ string: Strings.Pro) -> String {
        string.value
    }
    
    public func buyPro(onSuccess: (() -> Void)? = nil, onError: ((BudgetError) -> Void)? = nil) {
        if isAcceptedTerms {
            fetchProducts()
        } else { onError?(.dontAcceptedTerms) }
    }
    
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set([mothlySubscriptionID]))
        request.delegate = self
        request.start()
    }
    
    func purchase() {
        if let product = products[mothlySubscriptionID] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension ProPresenter: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers.forEach { print("Invalid: \($0)") }
        response.products.forEach {
            print("Valid: \($0)")
            products[$0.productIdentifier] = $0
            purchase()
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error for request: \(error.localizedDescription)")
    }
}
