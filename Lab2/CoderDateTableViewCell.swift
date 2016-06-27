//
//  CoderDateTableViewCell.swift
//  Lab2
//
//  Created by hoaqt on 6/27/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit

class CoderDateTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
