//
//  PersistentContainer.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2019/10/16.
//  Copyright © 2019 Dixi-Chen. All rights reserved.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer{
    override class func defaultDirectoryURL() -> URL{
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.cdx.ColourKitGroup")!
    }
 
    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
    }
}
