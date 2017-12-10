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
    
    func avg() -> Double {
        let fr = NSFetchRequest<NSFetchRequestResult>  (entityName: "Reading")
        fr.resultType = .dictionaryResultType
        let ed = NSExpressionDescription()
        ed.name = "avg"
        ed.expression = NSExpression(format: "@avg.value")
        ed.expressionResultType = .doubleAttributeType
        
        fr.propertiesToFetch = [ed]
        
        let result = try? moc.fetch(fr) as? [NSDictionary]
        let avg = result??.first?["avg"] as! Double
        
        return avg
    }
    
    func avgForSensor() -> [AvgSensor] {
        
        let fr = NSFetchRequest<NSFetchRequestResult>  (entityName: "Sensor")
        fr.resultType = .dictionaryResultType
        let ed = NSExpressionDescription()
        ed.name = "avg"
        ed.expression = NSExpression(format: "@avg.readings.value")
        ed.expressionResultType = .doubleAttributeType
        
        let ed3 = NSExpressionDescription()
        ed3.name = "name"
        ed3.expression = NSExpression(format: "name")
        ed3.expressionResultType = .stringAttributeType
        
        let ed2 = NSExpressionDescription()
        ed2.name = "count"
        ed2.expression = NSExpression(format: "readings.@count")
        ed2.expressionResultType = .integer32AttributeType
        
        
        fr.propertiesToFetch = [ed, ed2, ed3]
       
        
        let result = try? moc.fetch(fr) as? [NSDictionary]
        
        var toReturn: [AvgSensor] = [];
      
        for r in result!! {
            let name = r["name"] as! String
            var avg = 0.0;
            if r["avg"] != nil {
                avg = r["avg"] as! Double
            }
            let count = r["count"] as! Int
            toReturn.append(AvgSensor(sensor: name, count: count, avg: avg))
        }
        
        return toReturn

        
    }
    
    func minMaxTimestamp() -> [Int] {
        let fr = NSFetchRequest<NSFetchRequestResult>  (entityName: "Reading")
        fr.resultType = .dictionaryResultType
        let ed = NSExpressionDescription()
        ed.name = "MinimumTimestamp"
        ed.expression = NSExpression(format: "@min.timestamp")
        ed.expressionResultType = .integer32AttributeType
        
        let ed2 = NSExpressionDescription()
        ed2.name = "MaximumTimestamp"
        ed2.expression = NSExpression(format: "@max.timestamp")
        ed2.expressionResultType = .integer32AttributeType
        fr.propertiesToFetch = [ed, ed2]

        let result = try? moc.fetch(fr) as? [NSDictionary]
        let max = result??.first?["MaximumTimestamp"] as! Int
        let min = result??.first?["MinimumTimestamp"] as! Int
        
        return [min, max];
        
    }
    
    func generateReadings(count: Int){
        
        let fr = NSFetchRequest<Sensor>(entityName: "Sensor");
        let sensors = try? moc.fetch(fr);
        
        for _ in 1...count {
            let randomIndex = Int(arc4random_uniform(UInt32((sensors?.count)!)))
            let sensor = sensors?[randomIndex]
            
            let entity = NSEntityDescription.entity  (forEntityName: "Reading", in: moc)
            let timestamp = self.randomTimestamp(base: Int(Date().timeIntervalSince1970))
            
            let value = self.randomValue(min: 0.0, max: 100.0)
            let reading = NSManagedObject(entity: entity!, insertInto: moc)

            reading.setValue(sensor, forKey: "sensor")
            reading.setValue(timestamp, forKey: "timestamp")
            reading.setValue(value, forKey: "value")
            
            sensor?.readings = sensor?.readings?.adding(reading) as NSSet?
            
        }
        try? moc.save()
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
