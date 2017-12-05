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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        self.manager = SensorManager(db: appDelegate.sqliteManager!.db);
        self.manager!.create();
        self.manager!.clear();
        self.manager!.insert(count: 20);
        self.sensors = self.manager!.getAll();
        super.viewDidLoad();
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
