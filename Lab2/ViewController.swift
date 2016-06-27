//
//  ViewController.swift
//  Lab2
//
//  Created by TriNgo on 6/27/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var coderDateTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        coderDateTableView.delegate = self
        coderDateTableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: tableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CoderDateTableViewCell
        cell.profileName.text = "Hoa"
        return cell
    }
}

//MARK: tableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

