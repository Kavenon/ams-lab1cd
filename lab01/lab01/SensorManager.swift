//
//  SensorCreator.swift
//  lab01
//
//  Created by Kamil on 12/5/17.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import Foundation

class SensorManager {
    
    var sqlite: SqliteManager;
    
    init(sqlite: SqliteManager){
        self.sqlite = sqlite;
    }
    
    func create(){
        self.sqlite.connect();
        let sql = "" +
        "CREATE TABLE IF NOT EXISTS sensor(" +
            "name VARCHAR(50) PRIMARY KEY NOT NULL," +
            "desc VARCHAR(255)" +
        ");";
        if sqlite3_exec(self.sqlite.db, sql, nil, nil, nil) == SQLITE_OK {
            print("Created table sensor");
        }
        else {
            print("Create table failed");
        }
        self.sqlite.disconnect();
    }
    
    func insert(count: Int){
        self.sqlite.connect();
        for index in 1...count {
            let name = index < 10 ? "S0" + String(index) : "S" + String(index);
            let desc = "Sensor number " + String(index);
            let sql = "INSERT INTO sensor (name, desc) VALUES ('\(name)', '\(desc)');";
            sqlite3_exec(self.sqlite.db, sql, nil, nil, nil);
        }
        print ("Sensors insert finished");
        self.sqlite.disconnect();
        
    }
    
    func clear(){
        self.sqlite.connect();
        let sql = "DELETE FROM sensor;";
        let result = sqlite3_exec(self.sqlite.db, sql, nil, nil, nil);
        print("Clear result: " + String(result));
        self.sqlite.disconnect();
    }
    
    func getAll() -> [Sensor] {
        self.sqlite.connect();
        let sql = "SELECT name, desc FROM sensor;";
        var stmt: OpaquePointer? = nil;
        var result: [Sensor] = [];
        
        sqlite3_prepare_v2(self.sqlite.db, sql, -1, &stmt, nil);
        while sqlite3_step(stmt) == SQLITE_ROW {
            let name = String(cString: sqlite3_column_text(stmt, 0));
            let desc = String(cString: sqlite3_column_text(stmt, 1));
            result.append(Sensor(name: name, desc: desc));
        }
        sqlite3_finalize(stmt);
        self.sqlite.disconnect();
        return result;
    }
    
    
    
}
