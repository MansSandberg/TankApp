//
//  Model.swift
//  TankApp
//
//  Created by Måns Sandberg on 2015-01-11.
//  Copyright (c) 2015 Måns Sandberg. All rights reserved.
//

import UIKit
import CoreData

@objc(Model)

class Model: NSManagedObject {
    @NSManaged var liter: Float
    @NSManaged var kronor: Float
    @NSManaged var literpris: Float
    @NSManaged var datum: NSDate
    @NSManaged var sorteringsDatum:String
}