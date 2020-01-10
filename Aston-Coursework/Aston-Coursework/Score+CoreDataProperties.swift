//
//  Score+CoreDataProperties.swift
//  Aston-Coursework
//
//  Created by A&M on 09/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score")
    }

    @NSManaged public var name: String?
    @NSManaged public var score: Int16

}
