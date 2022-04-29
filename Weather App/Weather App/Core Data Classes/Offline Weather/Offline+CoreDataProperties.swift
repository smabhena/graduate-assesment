//
//  Offline+CoreDataProperties.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/28.
//
//

import Foundation
import CoreData

extension Offline {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Offline> {
        return NSFetchRequest<Offline>(entityName: "Offline")
    }

    @NSManaged public var name: String?
    @NSManaged public var weather: String?
    @NSManaged public var tempreture: String?
    @NSManaged public var time: String?

}

extension Offline : Identifiable {

}
