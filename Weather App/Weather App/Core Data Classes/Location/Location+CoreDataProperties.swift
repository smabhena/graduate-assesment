//
//  Location+CoreDataProperties.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/27.
//
//

import Foundation
import CoreData

extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var location: String?

}

extension Location : Identifiable {

}
