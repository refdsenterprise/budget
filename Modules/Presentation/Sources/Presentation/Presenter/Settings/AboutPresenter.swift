//
//  AboutPresenter.swift
//  
//
//  Created by Rafael Santos on 30/03/23.
//

import SwiftUI
import Domain
import Resource
import StoreKit

public enum AboutLinks {
    case website
    case github
    case appleStore
    case policy
    
    public var url: URL {
        switch self {
        case .website: return URL(string: "https://budget.rafaelescaleira.com.br")!
        case .github: return URL(string: "https://github.com/refdsenterprise/budget")!
        case .appleStore: return URL(string: "https://apps.apple.com/us/app/budget/id6448043784")!
        case .policy: return URL(string: "https://budget.rafaelescaleira.com.br/privacy-policy")!
        }
    }
}

public protocol AboutPresenterProtocol: ObservableObject {
    var urlShareItem: ShareItem { get set }
    var appShareItem: ShareItem { get set }
    var appVersion: String { get }
    
    func link(_ link: AboutLinks) -> URL
    func string(_ string: Strings.About) -> String
    func requestReview()
}

public final class AboutPresenter: AboutPresenterProtocol {
    @Published public var urlShareItem: ShareItem = .init()
    @Published public var appShareItem: ShareItem = .init()
    public var appVersion: String {
        "  \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")  "
    }
    
    public init() {}
    
    public func string(_ string: Strings.About) -> String {
        string.value
    }
    
    public func link(_ link: AboutLinks) -> URL {
        link.url
    }
    
    public func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first, let windowScene = scene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
