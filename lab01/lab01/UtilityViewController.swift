//
//  FirstViewController.swift
//  lab01
//
//  Created by Użytkownik Gość on 01.12.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit
import CoreData

class UtilityViewController: UIViewController {

    @IBOutlet var recordField: UITextField!
    @IBOutlet var runButton: UIButton!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var deleteButton: UIButton!			
    @IBOutlet var logText: UITextView!
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    @IBAction func forSensorClick(_ sender: Any) {
        
        let start = NSDate();
        let forSensor = self.dataManager.avgForSensor();
        let took = NSDate().timeIntervalSince(start as Date);
        self.logText.insertText("Stats per sensor\n");
        for row in forSensor {
            self.logText.insertText("Sensor \(row.sensor) - \(row.count) - \(row.avg)\n");
        }
        self.logText.insertText("Took \(took)\n-----------------\n");

    }
    
    @IBAction func avgClick(_ sender: Any) {
        let start = NSDate();
        let avg = self.dataManager.avg();
        let took = NSDate().timeIntervalSince(start as Date);
        self.logText.insertText("Average \(avg) reading \n");
        self.logText.insertText("Took \(took)\n-----------------\n");
    }
    
    @IBAction func minMaxClick(_ sender: Any) {
        let start = NSDate();
        let minmax = self.dataManager.minMaxTimestamp();
        let took = NSDate().timeIntervalSince(start as Date);
        self.logText.insertText("[min,max] \(minmax) timestamps\n");
        self.logText.insertText("Took \(took)\n-----------------\n");
    }
    
    @IBAction func generateClick(_ sender: Any) {
        var count = 0;
        if recordField.text != "" {
            count = Int(recordField.text!)!
        }
        
        if count > 0 {
            
            self.dataManager.insertSensorsIfNeed(count: 20)
            
            let start = NSDate();
            self.dataManager.generateReadings(count: count)
            let took = NSDate().timeIntervalSince(start as Date);
            recordField.text = "";
            self.logText.insertText("Inserted \(count) readings\n");
            self.logText.insertText("Took \(took)\n-----------------\n");
        }
            
    }
   
    @IBAction func deleteClick(_ sender: UIButton) {
        self.logText.text = "";
        self.logText.insertText("Cleared readings\n");
        self.dataManager.deleteAll();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

