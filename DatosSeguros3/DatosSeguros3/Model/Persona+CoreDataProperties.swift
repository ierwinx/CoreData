//
//  Persona+CoreDataProperties.swift
//  DatosSeguros3
//
//  Created by Erwin on 19/10/20.
//  Copyright © 2020 Erwin. All rights reserved.
//
//

import Foundation
import CoreData


extension Persona {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Persona> {
        return NSFetchRequest<Persona>(entityName: "Persona")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nombre: String?
    @NSManaged public var caminatas: NSOrderedSet?

}

// MARK: Generated accessors for caminatas
extension Persona {

    @objc(insertObject:inCaminatasAtIndex:)
    @NSManaged public func insertIntoCaminatas(_ value: Caminadas, at idx: Int)

    @objc(removeObjectFromCaminatasAtIndex:)
    @NSManaged public func removeFromCaminatas(at idx: Int)

    @objc(insertCaminatas:atIndexes:)
    @NSManaged public func insertIntoCaminatas(_ values: [Caminadas], at indexes: NSIndexSet)

    @objc(removeCaminatasAtIndexes:)
    @NSManaged public func removeFromCaminatas(at indexes: NSIndexSet)

    @objc(replaceObjectInCaminatasAtIndex:withObject:)
    @NSManaged public func replaceCaminatas(at idx: Int, with value: Caminadas)

    @objc(replaceCaminatasAtIndexes:withCaminatas:)
    @NSManaged public func replaceCaminatas(at indexes: NSIndexSet, with values: [Caminadas])

    @objc(addCaminatasObject:)
    @NSManaged public func addToCaminatas(_ value: Caminadas)

    @objc(removeCaminatasObject:)
    @NSManaged public func removeFromCaminatas(_ value: Caminadas)

    @objc(addCaminatas:)
    @NSManaged public func addToCaminatas(_ values: NSOrderedSet)

    @objc(removeCaminatas:)
    @NSManaged public func removeFromCaminatas(_ values: NSOrderedSet)

}
