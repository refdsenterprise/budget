//
//  Worker.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI

public final class Worker {
    public static let shared = Worker()
    public let category: CategoryWorker = .shared
    public let transaction: TransactionWorker = .shared
    public let settings: SettingsWorker = .shared
    public let bubble: BubbleWorker = .shared
}
