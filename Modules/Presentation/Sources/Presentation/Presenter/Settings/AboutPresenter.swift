//
//  AboutPresenter.swift
//  
//
//  Created by Rafael Santos on 30/03/23.
//

import SwiftUI
import Domain
import Resource

public enum AboutLinks {
    case website
    case github
    case appleStore
    
    public var url: URL {
        switch self {
        case .website: return URL(string: "https://budget.refds.com.br")!
        case .github: return URL(string: "https://github.com/refdsenterprise/budget")!
        case .appleStore: return URL(string: "https://apps.apple.com/br/app/cartola-oficial/id1129547202")!
        }
    }
}

public protocol AboutPresenterProtocol: ObservableObject {
    var urlShareItem: ShareItem { get set }
    var appShareItem: ShareItem { get set }
    
    func link(_ link: AboutLinks) -> URL
    func string(_ string: Strings.About) -> String
}

public final class AboutPresenter: AboutPresenterProtocol {
    @Published public var urlShareItem: ShareItem = .init()
    @Published public var appShareItem: ShareItem = .init()
    
    public init() {}
    
    public func string(_ string: Strings.About) -> String {
        string.value
    }
    
    public func link(_ link: AboutLinks) -> URL {
        link.url
    }
}
