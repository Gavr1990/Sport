//
//  SportEntity+CoreDataProperties.swift
//  Sport
//
//  Created by Андрей Гаврилов on 13.04.2022.
//
//

import Foundation
import CoreData


extension SportEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SportEntity> {
        return NSFetchRequest<SportEntity>(entityName: "SportEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var place: String?
    @NSManaged public var time: String?
    @NSManaged public var isDataFromFirebase: String?

}

extension SportEntity : Identifiable {

}
