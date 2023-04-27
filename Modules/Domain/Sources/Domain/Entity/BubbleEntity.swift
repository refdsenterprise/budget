//
//  BubbleEntity.swift
//  
//
//  Created by Rafael Santos on 25/04/23.
//

import Foundation
import CoreData

@objc(BubbleEntity)
public class BubbleEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BubbleEntity> {
        return NSFetchRequest<BubbleEntity>(entityName: "BubbleEntity")
    }

    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
}
