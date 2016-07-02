//
//  DetailViewController.swift
//  Lab2
//
//  Created by TriNgo on 7/2/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit
import Answers

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
        
        let attrs = ["Name": "\(name)", "birthdate":"\(dob)"]
        Answers.logCustomEventWithName("Singer detail", customAttributes: attrs)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
