//
//  ProfileTableViewCell.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var verifyImageView: UIImageView!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var collegeBtn: UIButton!
    @IBOutlet weak var collegeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collegeLabel.text = User.currentUser().domain.uppercaseString        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
