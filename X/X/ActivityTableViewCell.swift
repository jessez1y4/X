//
//  ActivityTableViewCell.swift
//  X
//
//  Created by yue zheng on 1/1/15.
//  Copyright (c) 2015 PPC. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var numberView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setValues(post: Post) {
        contentLabel.text = post.content
        lifeLabel.text = post.getTTL()
        numberLabel.text = "\(post.unread)"
        
        if post.unread == 0 {
            numberView.hidden = true
        }
    }

}
