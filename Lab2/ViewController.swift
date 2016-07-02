//
//  ViewController.swift
//  Lab2
//
//  Created by TriNgo on 6/27/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit
import AFNetworking
import Answers

class ViewController: UIViewController {

    let CANCEL:Int = 0
    let DONE:Int = 1
    let LISTVIEW:Int = 0
    let GRIDVIEW:Int = 1
    
    @IBOutlet weak var singersTableView: UITableView!

    var subView: CustomAlertController!
    var datas = [NSDictionary]()
    var limit = 5
    var offset = 0
    var displayMode = 0 //list view display by defaut
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singersTableView.delegate = self
        singersTableView.dataSource = self
        
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
                    self.singersTableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Show more
    @IBAction func showMore(sender: UIBarButtonItem) {
        offset += limit
        offset = offset <= 17 ? offset : 17
        loadDataFromNetwork(offset, limit: limit)
        
        Answers.logCustomEventWithName("Show more", customAttributes: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = singersTableView.indexPathForCell(sender as! UITableViewCell)
        let vc = segue.destinationViewController as! DetailViewController
        vc.detailData = datas[(indexPath?.row)!]
    }
}

// MARK: tableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("singerCell") as! SingerCell
        let data = datas[indexPath.row]
        
        cell.nameLabel.text = data["name"] as? String
        if let imagePath = data["picture"] as? String {
            let imageUrl = NSURL(string: imagePath)
            cell.singerImageView.setImageWithURL(imageUrl!)
        }
        return cell
    }
    
    // Animate Table View Cell
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animateWithDuration(0.6, animations: {() -> Void in
            cell.layer.transform = CATransform3DIdentity
        })
    }
}

// MARK: tableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count ?? 0
    }
}

// MARK: - ActionSheet
extension ViewController: SwiftAlertViewDelegate {
    
    @IBAction func onSettingsClick(sender: UIBarButtonItem) {

        subView = CustomAlertController(frame: CGRectMake(0, 20, view.bounds.width - 20, 200))
        let alertView = SwiftAlertView(contentView: subView, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Done")
        alertView.show()

    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case DONE:
            offset = subView.offset!
            limit = subView.limit!
            displayMode = subView.displayMode!
            print("displayMode: \(displayMode == 0 ? "ListView" : "GridView"), offset: \(offset), limit: \(limit)")
            break
        default:
            break
        }
    }
    
    func willPresentAlertView(alertView: SwiftAlertView) {
        subView.offset = offset
        subView.limit = limit
        subView.displayMode = displayMode
    }
    
}





