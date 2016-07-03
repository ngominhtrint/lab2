//
//  DetailViewController.swift
//  Lab2
//
//  Created by TriNgo on 7/2/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit
import Answers
import Optimizely

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var singerImageView: UIImageView!
    
    var detailData: NSDictionary? = nil
    
    internal var messageKey =
        OptimizelyVariableKey.optimizelyKeyWithKey("message", defaultNSString: "Hello World!")
    
    internal var reportTimeBlocksKey =
        OptimizelyCodeBlocksKey("reportTimeBlocks", blockNames: ["alert", "button"])

    
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
        
        
        let messageButton = UIButton(type: UIButtonType.System)
        messageButton.setTitle("Show Message", forState: UIControlState.Normal)
        messageButton.addTarget(self, action: #selector(self.showMessage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        messageButton.frame = CGRectMake(25, 60, 200, 50)
        view.addSubview(messageButton)

        let blockButton = UIButton(type: UIButtonType.System)
        blockButton.setTitle("Report Time", forState: UIControlState.Normal)
        blockButton.addTarget(self, action: #selector(self.reportTime(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        blockButton.frame = CGRectMake(100, 60, 300, 50)
        view.addSubview(blockButton)

        let trackEventButton = UIButton(type: UIButtonType.System)
        trackEventButton.setTitle("Checkout", forState: UIControlState.Normal)
        trackEventButton.addTarget(self, action: #selector(self.checkout(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        trackEventButton.frame = CGRectMake(25, 160, 300, 50)
        view.addSubview(trackEventButton)

    }

    @IBAction func showMessage(sender: AnyObject) {
        let alert = UIAlertController(title: "Live Variable",
                                      message: Optimizely.stringForKey(messageKey),
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil))
        presentViewController(alert, animated: true) {}
    }

    @IBAction func reportTime(sender: AnyObject) {
        let message = NSString(format: "It is %@", NSDate()) as String;
        Optimizely.codeBlocksWithKey(reportTimeBlocksKey,
                                     blockOne: {
                                        let alert = UIAlertController(title: "Live Variable",
                                            message: message,
                                            preferredStyle: UIAlertControllerStyle.Alert)
                                        alert.addAction(UIAlertAction(title: "OK",
                                            style: UIAlertActionStyle.Default,
                                            handler: { (action) -> Void in }))
                                        self.presentViewController(alert, animated: true) {}
            },
                                     blockTwo: {
                                        sender.setTitle(message, forState: UIControlState.Normal)
            },
                                     defaultBlock: {
                                        print(message)
        })
    }
    
    @IBAction func checkout(sender: AnyObject) {
        Optimizely.trackEvent("start_checkout")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
