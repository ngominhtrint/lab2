//
//  DetailViewController.swift
//  Lab2
//
//  Created by TriNgo on 7/2/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var singerImageView: UIImageView!
    
    var detailData: NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageUrl = detailData!["picture"] as! String
        let name = detailData!["name"] as! String
        let height = detailData!["height"]
        let dob = detailData!["birthdate"] as! String
        
        singerImageView.setImageWithURL(NSURL(string: imageUrl)!)
        nameLabel.text = name
        heightLabel.text = String(height!).isEmpty ? "" : String(height!)
        dobLabel.text = dob
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
