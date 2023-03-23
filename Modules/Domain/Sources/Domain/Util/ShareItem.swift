//
//  ShareItem.swift
//  
//
//  Created by Rafael Santos on 15/03/23.
//

import Foundation

public struct ShareItem {
    public var isPresented: Bool
    public var url: URL?
    
    public init() {
        self.isPresented = false
        self.url = nil
    }
    
    public init(isPresented: Bool, url: URL?) {
        self.isPresented = isPresented
        self.url = url
    }
}
