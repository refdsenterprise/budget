//
//  CoreDataAttributeDescription.swift
//  CoreDataModelDescription
//
//  Created by Dmytro Anokhin on 12/08/2019.
//  Copyright © 2019 Dmytro Anokhin. All rights reserved.
//

import CoreData


/// Describes and creates`NSAttributeDescription`
public struct CoreDataAttributeDescription {
    public static func attribute(
        name: String,
        type: NSAttributeType,
        isOptional: Bool = false,
        defaultValue: Any? = nil,
        isIndexedBySpotlight: Bool = false,
        attributeValueClassName: String? = nil,
        valueTransformerName: String? = nil
    ) -> CoreDataAttributeDescription {
        return CoreDataAttributeDescription(
            name: name,
            attributeType: type,
            isOptional: isOptional,
            defaultValue: defaultValue,
            isIndexedBySpotlight: isIndexedBySpotlight,
            attributeValueClassName: attributeValueClassName,
            valueTransformerName: valueTransformerName
        )
    }

    public var name: String
    public var attributeType: NSAttributeType
    public var isOptional: Bool
    public var defaultValue: Any?
    public var isIndexedBySpotlight: Bool
    public var attributeValueClassName: String?
    public var valueTransformerName: String?

    public func makeAttribute() -> NSAttributeDescription {
        let attribute = NSAttributeDescription()        
        attribute.name = name
        attribute.attributeType = attributeType
        attribute.isOptional = isOptional
        attribute.defaultValue = defaultValue
        attribute.isIndexedBySpotlight = isIndexedBySpotlight
        if let attributeValueClassName = attributeValueClassName {
            attribute.attributeValueClassName = attributeValueClassName
        }
        attribute.valueTransformerName = valueTransformerName
        return attribute
    }
}
