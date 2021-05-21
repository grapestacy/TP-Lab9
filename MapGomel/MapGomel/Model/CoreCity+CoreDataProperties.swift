//
//  CoreCity+CoreDataProperties.swift
//  MapGomel
//
//  Created by Stacy Vinogradova on 29.04.21.
//
//

import Foundation
import CoreData


extension CoreCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreCity> {
        return NSFetchRequest<CoreCity>(entityName: "CoreCity")
    }

    @NSManaged public var name: String?
    @NSManaged public var musems: String?
    @NSManaged public var longitude: Float
    @NSManaged public var latitude: Float

}

extension CoreCity : Identifiable {

}
