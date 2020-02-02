//
//  coreDataHelper.swift
//  CoreDataPreloadTest
//
//  Created by Chris Holschuh on 2/2/20.
//  Copyright © 2020 Chris Holschuh. All rights reserved.
//
import UIKit
import Foundation
import CoreData


class coreDataHelper: NSObject {
    
    private class func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    class func recordVistedLoc(name: String)-> Bool{
        do {
            let context = getContext()
            //let entity =  NSEntityDescription.entity(forEntityName: "VistedRoomsMO", in: context)
            let vistedRooms = VisitedRoomsMO(context: context)
            vistedRooms.name = name
            try context.save()
            return true
        }catch{
            print(error.localizedDescription)
            return false
        }
    }
    
    class func clearAllVistedLoc () -> Bool{
        let context = getContext()
        let deleteAllRequest = NSBatchDeleteRequest(fetchRequest: VisitedRoomsMO.fetchRequest())
        
        do {
            try context.execute(deleteAllRequest)
            try context.save()
            return true
        }catch{
            print (error.localizedDescription)
            return false
        }
        
    }
    
}
    

