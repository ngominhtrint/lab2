//
//  SingerCell.swift
//  Lab2
//
//  Created by TriNgo on 7/2/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit

class SingerCell: UITableViewCell {

    @IBOutlet weak var singerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
