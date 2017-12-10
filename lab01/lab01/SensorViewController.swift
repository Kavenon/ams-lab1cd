//
//  SensorViewController.swift
//  lab01
//
//  Created by Kamil on 12/3/17.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit
import CoreData

class SensorViewController: UITableViewController {
    
    var sensors: [Sensor] = [];
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.sensors.count);
    }
  
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "sensorCell");
        cell.textLabel?.text = self.sensors[indexPath.row].name;
        cell.detailTextLabel?.text = self.sensors[indexPath.row].desc;
        return (cell);
    }
    
    override func viewDidLoad() {
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0);
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let moc = appDelegate.persistentContainer.viewContext;
        let fr = NSFetchRequest<Sensor>(entityName: "Sensor");
        
        do {
            try sensors = moc.fetch(fr);
        }
        catch {
            print("sensor fetch failed");
        }
        
        super.viewDidLoad();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
