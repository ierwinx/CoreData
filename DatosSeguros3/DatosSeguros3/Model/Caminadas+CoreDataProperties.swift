//
//  Caminadas+CoreDataProperties.swift
//  DatosSeguros3
//
//  Created by Erwin on 19/10/20.
//  Copyright © 2020 Erwin. All rights reserved.
//
//

import Foundation
import CoreData


extension Caminadas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Caminadas> {
        return NSFetchRequest<Caminadas>(entityName: "Caminadas")
    }

    @NSManaged public var fecha: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var persona: Persona?

}
