//
//  Database.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import Foundation
import RefdsCore
import Domain
import SwiftUI
import CoreData

public final class Database: ObservableObject {
    static let shared = Database()
    
    private lazy var coreDataModel: NSManagedObjectModel = {
        let description = CoreDataModelDescription(entities: [
            .entity(
                name: "BudgetEntity",
                managedObjectClass: BudgetEntity.self,
                attributes: [
                    .attribute(name: "id", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "amount", type: .doubleAttributeType, isOptional: true),
                    .attribute(name: "message", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "category", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "date", type: .dateAttributeType, isOptional: true),
                ]
            ),
            .entity(
                name: "TransactionEntity",
                managedObjectClass: TransactionEntity.self,
                attributes: [
                    .attribute(name: "id", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "amount", type: .doubleAttributeType, isOptional: true),
                    .attribute(name: "message", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "category", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "date", type: .dateAttributeType, isOptional: true),
                ]
            ),
            .entity(
                name: "CategoryEntity",
                managedObjectClass: CategoryEntity.self,
                attributes: [
                    .attribute(name: "id", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "color", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "name", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "budgets", type: .transformableAttributeType, isOptional: true, attributeValueClassName: "[UUID]", valueTransformerName: "NSSecureUnarchiveFromDataTransformer")
                ]
            ),
            .entity(
                name: "SettingsEntity",
                managedObjectClass: SettingsEntity.self,
                attributes: [
                    .attribute(name: "date", type: .dateAttributeType, isOptional: true),
                    .attribute(name: "theme", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "appearence", type: .doubleAttributeType, isOptional: true),
                    .attribute(name: "notifications", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "reminderNotification", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "warningNotification", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "breakingNotification", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "currentWarningNotificationAppears", type: .transformableAttributeType, isOptional: true, attributeValueClassName: "[UUID]", valueTransformerName: "NSSecureUnarchiveFromDataTransformer"),
                    .attribute(name: "currentBreakingNotificationAppears", type: .transformableAttributeType, isOptional: true, attributeValueClassName: "[UUID]", valueTransformerName: "NSSecureUnarchiveFromDataTransformer"),
                    .attribute(name: "liveActivity", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "isPro", type: .booleanAttributeType, isOptional: true)
                ]
            ),
            .entity(
                name: "BubbleEntity",
                managedObjectClass: BubbleEntity.self,
                attributes: [
                    .attribute(name: "id", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "color", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "name", type: .stringAttributeType, isOptional: true)
                ]
            ),
        ])
        return description.makeModel()
    }()
    
    private lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "ApplicationEntity", managedObjectModel: self.coreDataModel)
        let storeURL = URL.storeURL(for: "group.budget.widget", databaseName: "ApplicationEntity")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.br.com.rafaelescaleira.Budget")
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return container.viewContext
    }()
}
