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
    var manager: ReadingManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        self.manager = ReadingManager(db: appDelegate.sqliteManager!.getDb());
        
    }
    
    @IBAction func createClick(_ sender: UIButton) {
        
        var count = 0;
        if recordField.text != nil {
            count = Int(recordField.text!)!
        }
        print(count);
        self.manager!.insert(count: count);
        print("inserted");
    }
    
    @IBAction func runClick(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        print("deleted");
        self.manager!.clear();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

