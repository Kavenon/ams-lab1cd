//
//  ReadingsTableViewController.swift
//  lab01
//
//  Created by Kamil on 12/5/17.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit
import CoreData

class ReadingsTableViewController: UITableViewController {

    var readings: [Reading] = [];
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.readings.count);
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "readingCell");
        cell.textLabel?.text = (self.readings[indexPath.row].sensor?.name)! + " " + String(self.readings[indexPath.row].value);
        cell.detailTextLabel?.text = String(self.readings[indexPath.row].timestamp);
        return (cell);
    }
    
    override func viewDidLoad() {
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0);
        super.viewDidLoad();
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool){
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        
        let moc = appDelegate.persistentContainer.viewContext;
        let fr = NSFetchRequest<Reading>(entityName: "Reading");
        
        do {
            try readings = moc.fetch(fr);
        }
        catch {
            print("reading fetch failed");
        }

        
        self.tableView.reloadData();

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
