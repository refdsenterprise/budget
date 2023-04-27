//
//  BubbleWorker.swift
//  
//
//  Created by Rafael Santos on 25/04/23.
//

import SwiftUI
import RefdsCore
import Domain
import CoreData

public final class BubbleWorker {
    public static let shared = BubbleWorker()
    private let database = Database.shared
    
    public func get(by id: UUID) -> BubbleEntity? {
        let request = BubbleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        guard let bubble = try? database.viewContext.fetch(request).first else { return nil }
        return bubble
    }
    
    public func get() -> [BubbleEntity] {
        let request = BubbleEntity.fetchRequest()
        guard let bubble = try? database.viewContext.fetch(request) else { return [] }
        return bubble
    }
    
    public func add(id: UUID, name: String, color: Color) throws {
        guard let bubble = get(by: id) else {
            let bubble = BubbleEntity(context: database.viewContext)
            bubble.id = id
            bubble.name = name.uppercased()
            bubble.color = color.toHex()
            try database.viewContext.save()
            return
        }
        bubble.id = id
        bubble.name = name.uppercased()
        bubble.color = color.toHex()
        try database.viewContext.save()
    }
    
    public func remove(id: UUID) throws {
        guard let bubble = get(by: id) else { return }
        database.viewContext.delete(bubble)
        try database.viewContext.save()
    }
}
