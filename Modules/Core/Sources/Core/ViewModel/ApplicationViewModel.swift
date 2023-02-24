//
//  ApplicationViewModel.swift
//  Budget
//
//  Created by Rafael Santos on 24/02/23.
//

import Foundation
import SwiftUI

public final class ApplicationViewModel: ObservableObject {
    @Published public var content: (() -> any View)?
    public init(content: (() -> any View)? = nil) {
        self.content = content
    }
}
