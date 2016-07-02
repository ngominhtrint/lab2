//
//  ViewController.swift
//  Lab2
//
//  Created by TriNgo on 6/27/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {
    @IBOutlet weak var coderDateTableView: UITableView!

    var datas = [NSDictionary]()
    var limit = 5
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coderDateTableView.delegate = self
        coderDateTableView.dataSource = self
        
        loadDataFromNetwork(0, limit: limit)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  loadDataFromNetwork(offset: Int, limit: Int) {
        let url = NSURL(string: "https://fancy-raptor.hyperdev.space?offset=\(offset)&limit=\(limit)")
        print(url!)
        
        let request = NSURLRequest(URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)

        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request) { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? [NSDictionary] {
                
                    self.datas = self.datas  + responseDictionary
                    print(self.datas)
                    self.coderDateTableView.reloadData()
                }
            }
        }
        
        task.resume()
        
    }
    
    
    @IBAction func showMore(sender: UIButton) {
        offset += limit
        loadDataFromNetwork(offset, limit: limit)
    }
}

//MARK: tableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CoderDateTableViewCell
        let data = datas[indexPath.row]
        
        cell.profileName.text = data["name"] as? String
        if let imagePath = data["picture"] as? String {
            let imageUrl = NSURL(string: imagePath)
            cell.profileImage.setImageWithURL(imageUrl!)
        }
        return cell
    }
}

//MARK: tableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count ?? 0
    }
}

