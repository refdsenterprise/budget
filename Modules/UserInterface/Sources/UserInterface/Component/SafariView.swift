//
//  SafariView.swift
//  
//
//  Created by Rafael Santos on 30/03/23.
//

import SwiftUI
import SafariServices

public struct SafariView: UIViewControllerRepresentable {
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        return
    }
}
