//
//  TimelineTableViewCell.swift
//  X
//
//  Created by yue zheng on 12/14/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leftHrLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var upvoteBtn: UIButton!
    
    @IBOutlet weak var helperVerticalView: UIView!
    var heightConstraint: NSLayoutConstraint? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentLabel.sizeToFit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentLabel.sizeToFit()
    }
    
    func setValues(post: Post) {
        contentLabel.text = post.content
        timeLabel.text = post.getPostTime()
        leftHrLabel.text = post.getTTL()
    }

}
