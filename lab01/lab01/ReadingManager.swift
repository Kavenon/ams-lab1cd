//
//  ReadingManager.swift
//  lab01
//
//  Created by Kamil on 12/5/17.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import Foundation

class ReadingManager {
    
    var sqlite: SqliteManager;
    
    init(manager: SqliteManager){
        self.sqlite = manager;
    }
    
    func create(){
        self.sqlite.connect();
        let sql = "" +
            "CREATE TABLE IF NOT EXISTS readings(" +
            "id INTEGER PRIMARY KEY, " +
            "sensor VARCHAR(50) REFERENCES sensor(name) NOT NULL, " +
            "timestamp INTEGER, " +
            "value REAL" +
        ");";
        if sqlite3_exec(self.sqlite.db, sql, nil, nil, nil) == SQLITE_OK {
            print("Created table readings");
        }
        else {
            print("Create table failed");
        }
        self.sqlite.disconnect();
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
    
    func randomValue(min: Double, max: Double) -> Double {
        let rand = Double(arc4random()) / 0xFFFFFFFF;
        return rand * (max - min) + min
    }
    
    func insert(count: Int){
        self.sqlite.connect();
        let sql = "INSERT INTO readings (timestamp, sensor, value) VALUES (?, ?, ?);";
        var stmt: OpaquePointer? = nil;
        if sqlite3_prepare(self.sqlite.db, sql, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_exec(self.sqlite.db, "BEGIN TRANSACTION", nil, nil, nil);
            for _ in 1...count {
                print("inserting");
                let timestamp = self.randomTimestamp(base: Int(Date().timeIntervalSince1970));
                let sensor = self.randomSensor(max: 20);
                let value = self.randomValue(min: 0.0, max:100.0);
                sqlite3_bind_int(stmt, 1, Int32(timestamp));
                sqlite3_bind_text(stmt, 2, sensor, -1, nil);
                sqlite3_bind_double(stmt, 3, Double(value));
                sqlite3_step(stmt);
                sqlite3_reset(stmt);
            }
            sqlite3_exec(self.sqlite.db, "COMMIT TRANSACTION", nil, nil, nil);
        }
        else {
            print("Error while creating statement");
        }
        
        sqlite3_finalize(stmt);
        print ("Reading insert finished");
        self.sqlite.disconnect();
        
    }
    
    func clear(){
        self.sqlite.connect();
        let sql = "DELETE FROM readings;";
        let result = sqlite3_exec(self.sqlite.db, sql, nil, nil, nil);
        print("Clear result: " + String(result));
        self.sqlite.disconnect();
    }
    
    func avgForSensor() -> [AvgSensor] {
        
        self.sqlite.connect();
        let sql = "SELECT sensor, count(*), avg(value) from readings group by sensor;";
        var stmt: OpaquePointer? = nil;
        sqlite3_prepare_v2(self.sqlite.db, sql, -1, &stmt, nil);
        var result: [AvgSensor] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let count = Int(sqlite3_column_int(stmt, 1));
            let sensor = String(cString: sqlite3_column_text(stmt, 0));
            let avg = Double(sqlite3_column_double(stmt, 2));
            result.append(AvgSensor(sensor: sensor, count: count, avg: avg));
        }
        
        sqlite3_finalize(stmt);
        self.sqlite.disconnect();
        
        return result;
        
    }
    
    func avg() -> Double {
        
        self.sqlite.connect();
        let sql = "SELECT avg(value) from readings;";
        var stmt: OpaquePointer? = nil;
        sqlite3_prepare_v2(self.sqlite.db, sql, -1, &stmt, nil);
        sqlite3_step(stmt);
        
        let avg = Double(sqlite3_column_double(stmt, 0));
        
        sqlite3_finalize(stmt);
        self.sqlite.disconnect();
        
        return avg;
        
    }
    
    func minMaxTimestampAndLog() -> [Int] {
        var result: [Int] = [];
        self.sqlite.connect();
        let sql = "SELECT min(timestamp), max(timestamp) from readings;";
        var stmt: OpaquePointer? = nil;
        sqlite3_prepare_v2(self.sqlite.db, sql, -1, &stmt, nil);
        sqlite3_step(stmt);
        
        result.append(Int(sqlite3_column_int(stmt, 0)));
        result.append(Int(sqlite3_column_int(stmt, 1)));
            
        sqlite3_finalize(stmt);
        self.sqlite.disconnect();
            
        return result;
        
    }
    
    func getAll() -> [Reading] {
        self.sqlite.connect();
        let sql = "SELECT timestamp, sensor, value FROM readings;";
        var stmt: OpaquePointer? = nil;
        var result: [Reading] = [];
        
        sqlite3_prepare_v2(self.sqlite.db, sql, -1, &stmt, nil);
        while sqlite3_step(stmt) == SQLITE_ROW {
            let timestamp = Int(sqlite3_column_int(stmt, 0));
            let sensor = String(cString: sqlite3_column_text(stmt, 1));
            let value = Double(sqlite3_column_double(stmt, 2));
            result.append(Reading(timestamp: timestamp, sensor: sensor, value: value));
        }
        sqlite3_finalize(stmt);
        self.sqlite.disconnect();
        
        return result;
        
    }


}
