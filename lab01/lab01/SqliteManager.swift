//
//  SqliteManager.swift
//  lab01
//
//  Created by Kamil on 12/5/17.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import Foundation

class SqliteManager {
    
    var db: OpaquePointer? = nil;
    
    func connect(){
        if self.db != nil {
            print("Database already connected");
            return;
        }
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("lab.db")?.path;
        
        let result = sqlite3_open(dbFilePath, &self.db);
        if result == SQLITE_OK{
            print("SQLite connected");
        }
        else {
            print ("SQLite connection error" + String(result));
        }

    }
        
    func disconnect(){
        if self.db == nil {
            print("Database already disconnected");
            return;
        }
        print("SQlite will disconnect");
        sqlite3_close(self.db);
        self.db = nil;
    }
}
