//
//  CategoryEntity+CoreDataClass.swift
//  
//
//  Created by Rafael Santos on 14/04/23.
//
//

import Foundation
import CoreData

@objc(CategoryEntity)
public class CategoryEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var budgets: [UUID]
    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
}
