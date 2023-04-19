//
//  ProPresenter.swift
//  
//
//  Created by Rafael Santos on 28/03/23.
//

import SwiftUI
import Domain
import Resource

public protocol ProPresenterProtocol: ObservableObject {
    var isAcceptedTerms: Bool { get set }
    var acceptedAlert: AlertItem { get set }
    
    func string(_ string: Strings.Pro) -> String
    func buyPro(onSuccess: (() -> Void)?, onError: ((BudgetError) -> Void)?)
}

public final class ProPresenter: ProPresenterProtocol {
    @Published public var isAcceptedTerms: Bool = false
    @Published public var acceptedAlert: AlertItem = .init()
    
    public init() {}
    
    public func string(_ string: Strings.Pro) -> String {
        string.value
    }
    
    public func buyPro(onSuccess: (() -> Void)? = nil, onError: ((BudgetError) -> Void)? = nil) {
        if isAcceptedTerms {
            
        } else { onError?(.dontAcceptedTerms) }
    }
}
