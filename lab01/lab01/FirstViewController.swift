//
//  FirstViewController.swift
//  lab01
//
//  Created by Użytkownik Gość on 01.12.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet var recordField: UITextField!
    @IBOutlet var runButton: UIButton!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var deleteButton: UIButton!			
    @IBOutlet var logText: UITextView!
    var manager: ReadingManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        self.manager = ReadingManager(manager: appDelegate.sqliteManager!);
        
    }

    @IBAction func forSensorClick(_ sender: Any) {
        
        let start = NSDate();
        let forSensor = self.manager!.avgForSensor();
        let took = NSDate().timeIntervalSince(start as Date);
        self.logText.insertText("Stats per sensor\n");
        for row in forSensor {
            self.logText.insertText("Sensor \(row.sensor) - \(row.count) - \(row.avg)\n");
        }
        self.logText.insertText("SELECT sensor, count(*), avg(value) from readings group by sensor");
        self.logText.insertText("Took \(took)\n-----------------\n");

    }
    
    @IBAction func avgClick(_ sender: Any) {
        let start = NSDate();
        let avg = self.manager!.avg();
        let took = NSDate().timeIntervalSince(start as Date);
        self.logText.insertText("Average \(avg) reading \n");
        self.logText.insertText("SELECT avg(value) from readings;");
        self.logText.insertText("Took \(took)\n-----------------\n");
    }
    
    @IBAction func minMaxClick(_ sender: Any) {
        let start = NSDate();
        let minmax = self.manager!.minMaxTimestampAndLog();
        let took = NSDate().timeIntervalSince(start as Date);
        self.logText.insertText("[min,max] \(minmax) timestamps\n");
        self.logText.insertText("SELECT min(timestamp), max(timestamp) from readings;");
        self.logText.insertText("Took \(took)\n-----------------\n");
    }
    
    @IBAction func generateClick(_ sender: Any) {
        var count = 0;
        if recordField.text != "" {
            count = Int(recordField.text!)!
        }
        
        if count > 0 {
            let start = NSDate();
            self.manager!.insert(count: count);
            let took = NSDate().timeIntervalSince(start as Date);
            recordField.text = "";
            self.logText.insertText("Inserted \(count) readings\n");
            self.logText.insertText("Took \(took)\n-----------------\n");
        }
    }
   
    @IBAction func deleteClick(_ sender: UIButton) {
        self.logText.text = "";
        self.logText.insertText("Cleared readings\n");
        self.manager!.clear();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

