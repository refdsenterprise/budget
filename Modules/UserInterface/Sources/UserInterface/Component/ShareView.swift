//
//  File.swift
//  
//
//  Created by Rafael Santos on 09/03/23.
//

import Foundation
import SwiftUI

public struct ShareView: UIViewControllerRepresentable {
    private var itemsToShare: [Any]
    private var servicesToShareItem: [UIActivity]?
    
    public init(itemsToShare: [Any], servicesToShareItem: [UIActivity]? = nil) {
        self.itemsToShare = itemsToShare
        self.servicesToShareItem = servicesToShareItem
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ShareView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: servicesToShareItem)
        controller.sheetPresentationController?.detents = [.medium(), .large()]
        return controller
    }
    
    public func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ShareView>
    ) {}
}
