//
//  SensorViewController.swift
//  lab01
//
//  Created by Kamil on 12/3/17.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit

class SensorViewController: UITableViewController {
    
    var db: OpaquePointer? = nil;
    var manager: SensorManager?;
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
        self.manager = SensorManager(sqlite: appDelegate.sqliteManager!);
        
        self.manager!.create();
        self.manager!.clear();
        self.manager!.insert(count: 20);
        self.sensors = self.manager!.getAll();
        super.viewDidLoad();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
