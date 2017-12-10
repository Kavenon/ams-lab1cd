//
//  SensorManager.swift
//  lab01
//
//  Created by Kamil on 12/10/17.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DataManager {
    
    let appDelegate: AppDelegate;
    let moc: NSManagedObjectContext;
    
    init(){
        appDelegate = UIApplication.shared.delegate as! AppDelegate;
        moc = appDelegate.persistentContainer.viewContext;
    }
    
    
    func insertSensors(count: Int){
        
        let entity = NSEntityDescription.entity  (forEntityName: "Sensor", in: moc)
        
        for index in 1...count {
            let sensor = NSManagedObject(entity: entity!, insertInto: moc)
            let name = index < 10 ? "S0" + String(index) : "S" + String(index);
            let desc = "Sensor number " + String(index);
            sensor.setValue(name, forKey: "name")
            sensor.setValue(desc, forKey: "desc")
            try? moc.save()
        }
        print("Inserting sensors finished");
    }
    
    func insertSensorsIfNeed(count: Int){
        let fr = NSFetchRequest<Sensor>(entityName: "Sensor");
        let sensors = try? moc.fetch(fr);
        
        if sensors?.count == 0 {
            print("Inserting sensors");
            self.insertSensors(count: 20)
        }
        
    }
    
    func randomTimestamp(base: Int) -> UInt32 {
        let max = 31556926;
        let random = arc4random_uniform(UInt32(max));
        return UInt32(base) - random;
    }
    
    func randomValue(min: Double, max: Double) -> Double {
        let rand = Double(arc4random()) / 0xFFFFFFFF;
        return rand * (max - min) + min
    }
    
    func generateReadings(count: Int){
        
        let fr = NSFetchRequest<Sensor>(entityName: "Sensor");
        let sensors = try? moc.fetch(fr);
        
        for _ in 1...count {
            let randomIndex = Int(arc4random_uniform(UInt32((sensors?.count)!)))
            let sensor = sensors?[randomIndex]
            
            let entity = NSEntityDescription.entity  (forEntityName: "Reading", in: moc)
            let timestamp = self.randomTimestamp(base: Int(Date().timeIntervalSince1970))
            print("test \(timestamp)")
            let value = self.randomValue(min: 0.0, max: 100.0)
            let reading = NSManagedObject(entity: entity!, insertInto: moc)

            reading.setValue(sensor, forKey: "sensor")
            reading.setValue(timestamp, forKey: "timestamp")
            reading.setValue(value, forKey: "value")
            
            sensor?.readings = sensor?.readings?.adding(reading) as NSSet?
            try? moc.save()
        }
        print ("generating done")
        
    }
    
    func deleteAll(){
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensor")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        let result = try? moc.execute(request)
        
        let fetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        let request2 = NSBatchDeleteRequest(fetchRequest: fetch2)
        let result2 = try? moc.execute(request2)
        
        print("Removing all finished \(result) \(result2)");
        
    }
}
