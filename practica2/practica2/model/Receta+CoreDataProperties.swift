//
//  Receta+CoreDataProperties.swift
//  practica2
//
//  Created by Grisel Angelica Perez Quezada on 28/02/23.
//
//

import Foundation
import CoreData


extension RecetaBebida {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receta> {
        return NSFetchRequest<Receta>(entityName: "Receta")
    }

    @NSManaged public var directions: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var name: String?
    @NSManaged public var img: String?

}

extension Receta : Identifiable {

}
