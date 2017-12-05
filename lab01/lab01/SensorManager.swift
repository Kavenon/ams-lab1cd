//
//  SensorCreator.swift
//  lab01
//
//  Created by Kamil on 12/5/17.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import Foundation

class SensorManager {
    
    var db: OpaquePointer?;
    
    init(db: OpaquePointer?){
        self.db = db;
    }
    
    func create(){
        let sql = "" +
        "CREATE TABLE IF NOT EXISTS sensor(" +
            "name VARCHAR(50) PRIMARY KEY NOT NULL," +
            "desc VARCHAR(255)" +
        ");";
        if sqlite3_exec(self.db, sql, nil, nil, nil) == SQLITE_OK {
            print("Created table sensor");
        }
        else {
            print("Create table failed");
        }
    }
    
    func insert(count: Int){
        
        for index in 1...count {
            let name = index < 10 ? "S0" + String(index) : "S" + String(index);
            let desc = "Sensor number " + String(index);
            let sql = "INSERT INTO sensor (name, desc) VALUES ('\(name)', '\(desc)');";
            sqlite3_exec(self.db, sql, nil, nil, nil);
        }
        print ("Sensors insert finished");
        
    }
    
    func clear(){
        let sql = "DELETE FROM sensor;";
        let result = sqlite3_exec(self.db, sql, nil, nil, nil);
        print("Clear result: " + String(result));
    }
    
    func getAll() -> [Sensor] {
        let sql = "SELECT name, desc FROM sensor;";
        var stmt: OpaquePointer? = nil;
        var result: [Sensor] = [];
        
        sqlite3_prepare_v2(self.db, sql, -1, &stmt, nil);
        while sqlite3_step(stmt) == SQLITE_ROW {
            let name = String(cString: sqlite3_column_text(stmt, 0));
            let desc = String(cString: sqlite3_column_text(stmt, 1));
            result.append(Sensor(name: name, desc: desc));
        }
        sqlite3_finalize(stmt);
        
        return result;
    }
    
    
    
}
