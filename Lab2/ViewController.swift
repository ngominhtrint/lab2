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
    @IBOutlet weak var singersCollectionView: UICollectionView!

    var subView: CustomAlertController!
    var datas = [NSDictionary]()
    var limit = 5
    var offset = 0
    var displayMode = 0 //list view display by defaut
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singersTableView.delegate = self
        singersTableView.dataSource = self
        singersCollectionView.delegate = self
        singersCollectionView.dataSource = self
        
        showListMode()
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
                    self.singersCollectionView.reloadData()
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
    
    func showListMode() {
        singersCollectionView.hidden = true
        singersTableView.hidden = false
    }
    
    func showGridMode() {
        singersCollectionView.hidden = false
        singersTableView.hidden = true
    }
    
    // MARK: - Switch list and collection
    func  switchListAndCollection() {
        switch displayMode {
        case LISTVIEW:
            showListMode()
            break
        case GRIDVIEW:
            showGridMode()
            break
        default:
            showListMode()
            break
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath:NSIndexPath!
        if singersTableView.hidden { // collection view is shown
            indexPath = singersCollectionView.indexPathForCell(sender as! UICollectionViewCell)
        } else {
            indexPath = singersTableView.indexPathForCell(sender as! UITableViewCell)
        }
        
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
//        cell.nameLabel.text = "Hari Won"
//        cell.singerImageView.setImageWithURL(NSURL(string: "http://images.herworldvietnam.vn/medias/2016/02/Hari-won-20.jpg")!)
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
//        return 10
    }
}

// MARK: - Collection View Delegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SingerCollectionCell", forIndexPath: indexPath) as! SingerCollectionCell
        
                let data = datas[indexPath.row]
                cell.nameLabel.text = data["name"] as? String
                if let imagePath = data["picture"] as? String {
                    let imageUrl = NSURL(string: imagePath)
                    cell.singerImageView.setImageWithURL(imageUrl!)
                }
        
//        cell.nameLabel.text = "Hari Won"
//        cell.singerImageView.setImageWithURL(NSURL(string: "http://images.herworldvietnam.vn/medias/2016/02/Hari-won-20.jpg")!)
        
        return cell
    }
}

// MARK: - Collection View Datasource
extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count ?? 0
//        return 10
    }
}

// MARK: - Settings
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
            switchListAndCollection()
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





