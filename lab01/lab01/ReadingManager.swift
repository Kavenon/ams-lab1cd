//
//  ReadingManager.swift
//  lab01
//
//  Created by Kamil on 12/5/17.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import Foundation

class ReadingManager {
    
    var db: OpaquePointer?;
    
    init(db: OpaquePointer?){
        self.db = db;
    }
    
    func create(){
        let sql = "" +
            "CREATE TABLE IF NOT EXISTS readings(" +
            "id INTEGER PRIMARY KEY, " +
            "sensor VARCHAR(50) REFERENCES sensor(name) NOT NULL, " +
            "timestamp INTEGER, " +
            "value REAL" +
        ");";
        if sqlite3_exec(self.db, sql, nil, nil, nil) == SQLITE_OK {
            print("Created table readings");
        }
        else {
            print("Create table failed");
        }
    }
    
    func randomSensor(max: Int) -> String {
        let random = arc4random_uniform(UInt32(max)) + 1;
        if(random < 10){
            return "S0" + String(random);
        }
        else {
            return "S" + String(random);
        }
    }
    
    func randomTimestamp(base: Int) -> Int {
        let max = 31556926;
        let random = arc4random_uniform(UInt32(max));
        return base - Int(random);
    }
    
    func randomValue(max: Int) -> Float {
        let v1 = Float(Int(arc4random_uniform(UInt32(max))) / max);
        return v1 * Float(max);
    }
    
    func insert(count: Int){
        
        let sql = "INSERT INTO reading (timestamp, sensor, value) VALUES (?, ?, ?);";
        var stmt: OpaquePointer? = nil;
        if sqlite3_prepare(self.db, sql, -1, &stmt, nil) == SQLITE_OK {
            for index in 1...count {
                let timestamp = self.randomTimestamp(base: Int(Date().timeIntervalSince1970));
                let sensor = self.randomSensor(max: 20);
                let value = self.randomValue(max: 100);
                sqlite3_bind_int(stmt, 1, Int32(timestamp));
                sqlite3_bind_text(stmt, 2, sensor, -1, nil);
                sqlite3_bind_double(stmt, 3, Double(value));
                sqlite3_step(stmt);
            }
        }
        else {
            print("Error while creating statement");
        }
        
        sqlite3_finalize(stmt);
        print ("Reading insert finished");
        
    }
    
    func clear(){
        let sql = "DELETE FROM reading;";
        let result = sqlite3_exec(self.db, sql, nil, nil, nil);
        print("Clear result: " + String(result));
    }
    
    func getAll() -> [Reading] {
        let sql = "SELECT timestamp, sensor, value FROM reading;";
        var stmt: OpaquePointer? = nil;
        var result: [Reading] = [];
        
        sqlite3_prepare_v2(self.db, sql, -1, &stmt, nil);
        while sqlite3_step(stmt) == SQLITE_ROW {
            let timestamp = Int(sqlite3_column_int(stmt, 0));
            let sensor = String(cString: sqlite3_column_text(stmt, 1));
            let value = Float(sqlite3_column_double(stmt, 2));
            result.append(Reading(timestamp: timestamp, value: value,sensor: sensor));
        }
        sqlite3_finalize(stmt);
        
        return result;
    }


}
