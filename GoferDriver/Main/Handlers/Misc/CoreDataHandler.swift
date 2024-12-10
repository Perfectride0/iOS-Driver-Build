//
//  CoreDataHandler.swift
//  GoferDriver
//
//  Created by trioangle on 31/10/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
import CoreData


/**
 Protocol for the Core Data Entity
 - Author: Abishek Robin
 - Warning: Implementer Should have Entity Name as Class name
 Eg :-
 Entity Name : SampleEntity
 Model Class Name : Sample
 */
protocol CoreDataModel : Codable{
}
extension CoreDataModel{
    /**
     gives entity name of class : "<CLASS_NAME>Entity"
     - Author: Abishek Robin
     */
    static var entityName :String{
        return String(describing: self)+"Entity"
    }
    
}
/**
 Generic<CoreDataModel> Core data operation handler
 - Author: Abishek Robin
 - Warning: object must be referred to CoreDataModel Protocol
 */
class CoreDataHandler<T: CoreDataModel>{
    private let appDelegate : AppDelegate
    private let context : NSManagedObjectContext
    
    init(){
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = self.appDelegate.persistentContainer.viewContext
    }
    private func getEntity() -> NSEntityDescription?{
        
        return NSEntityDescription.entity(forEntityName: T.entityName,
                                          in: self.context)
    }
    
    private func saveEntity(_ object : NSManagedObject){
        debug(print: "\(T.entityName)")
        do{
            
            try object.managedObjectContext?.save()// context.save()
        }catch{
            print("Core data save failed for entity : \(object.description)")
        }
    }
    /**
     remove all items in table
     - Author: Abishek Robin
     */
    func removeAll(){
        debug(print: "\(T.entityName)")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(T.entityName) error :", error)
        }
    }
    /**
     inserts row in to the entity
     - Author: Abishek Robin
     - Warning: Process might fail if datas are not correct
     */
    func store(data : T){
        debug(print: "\(T.entityName)")
        guard let entity = self.getEntity() else{return}
        let object = NSManagedObject(entity: entity, insertInto: self.context)
        do{
            let jsonData = try JSONEncoder().encode(data)
            
            do{
                let jsonDict = try JSONSerialization.jsonObject(with: jsonData,
                                                                options: []) as! JSON
                
                jsonDict.forEach { (key, value) in
                    
                    object.setValue(value, forKey: key)
                }
                
            }
            self.saveEntity(object)
        }catch let error {
            print("ƒ"+error.localizedDescription)
        }
    }
    /**
     Gets all the data from table
     - Author: Abishek Robin
     - Parameters:
     - onFetch : Array of core data model will be parsed back
     - Warning: Purpose must be parsed properly
     */
    func getData(_ onFetch : ([T]) -> () ){
        
        debug(print: "\(T.entityName)")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let jsonDecode = JSONDecoder()
            var objects = [T]()
            for data in result as? [NSManagedObject] ?? [NSManagedObject](){
                
                let json : JSON = data.dictionaryWithValues(forKeys: Array(data.entity.attributesByName.keys))
                
                let jsonData = try JSONSerialization.data(withJSONObject: json,
                                                          options: [])
                let item  = try jsonDecode.decode(T.self, from: jsonData)
                objects.append(item)
                
                
            }
            onFetch(objects)
        } catch let error{
            
            print("ƒFailed"+error.localizedDescription)
        }
    }
}
