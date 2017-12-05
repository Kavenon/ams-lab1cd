//
//  ReadingsTableViewController.swift
//  lab01
//
//  Created by Kamil on 12/5/17.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit

class ReadingsTableViewController: UITableViewController {

    var db: OpaquePointer? = nil;
    var manager: ReadingManager?;
    var readings: [Reading] = [];
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.readings.count);
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "readingCell");
        cell.textLabel?.text = self.readings[indexPath.row].sensor + " " + String(self.readings[indexPath.row].value);
        cell.detailTextLabel?.text = String(self.readings[indexPath.row].timestamp);
        return (cell);
    }
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        self.manager = ReadingManager(db: appDelegate.sqliteManager!.db);
        self.manager!.create();
        self.manager!.clear();
        self.manager!.insert(count: 20);
        self.readings = self.manager!.getAll();
        super.viewDidLoad();
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
