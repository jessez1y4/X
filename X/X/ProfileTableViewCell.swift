//
//  ProfileTableViewCell.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: PFImageView!
    @IBOutlet weak var verifyImageView: UIImageView!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var collegeBtn: UIButton!
    @IBOutlet weak var collegeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        println("go")
        // Initialization code
        
        collegeLabel.text = User.currentUser().domain.uppercaseString

        if User.currentUser().objectForKey("avatar") != nil {
            avatarImageView.file = User.currentUser().avatar
            avatarImageView.loadInBackground(nil)
        }
        
        if User.currentUser().verified {
            verifyBtn.hidden = true
            self.verifyImageView.image = UIImage(named: "Badge_Verified_Large.png")
        } else {
            self.verifyImageView.image = UIImage(named: "Badge_Non_Verified_Large.png")
        }
    }

    func loadAvatar() {
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
