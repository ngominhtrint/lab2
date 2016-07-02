//
//  CustomAlertController.swift
//  Lab2
//
//  Created by TriNgo on 7/3/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit

class CustomAlertController: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var limitSlider: UISlider!
    @IBOutlet weak var offsetSlider: UISlider!
    @IBOutlet weak var displayModeControl: UISegmentedControl!
    
    var offset: Int? {
        get { return Int((offsetSlider?.value)!) }
        set { offsetSlider.value = Float(newValue!) }
    }
    
    var limit: Int? {
        get { return Int((limitSlider?.value)!) }
        set { limitSlider.value = Float(newValue!) }
    }
    
    var displayMode: Int? {
        get { return displayModeControl.selectedSegmentIndex }
        set { displayModeControl.selectedSegmentIndex = newValue! }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "CustomAlertController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    @IBAction func onIndexChange(sender: UISegmentedControl) {
        
    }
}
