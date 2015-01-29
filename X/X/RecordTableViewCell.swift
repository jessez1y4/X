//
//  RecordTableViewCell.swift
//  X
//
//  Created by yue zheng on 12/28/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var longestLabel: UILabel!
    @IBOutlet weak var shortestLabel: UILabel!
    @IBOutlet weak var mostReplyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        longestLabel.text = String(User.currentUser().longestLife)
        shortestLabel.text = String(User.currentUser().shortestLife)
        mostReplyLabel.text = String(User.currentUser().mostReplies)
        
        User.currentUser().fetchInBackgroundWithBlock { (user, error) -> Void in
            if error == nil {
                self.longestLabel.text = String(User.currentUser().longestLife)
                self.shortestLabel.text = String(User.currentUser().shortestLife)
                self.mostReplyLabel.text = String(User.currentUser().mostReplies)
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
