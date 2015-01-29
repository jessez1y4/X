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
    @IBOutlet weak var avatarImageView: PFImageView!
    @IBOutlet weak var upvoteBtn: UIButton!
    @IBOutlet weak var downvoteBtn: UIButton!
    
    @IBOutlet weak var helperVerticalView: UIView!
    var heightConstraint: NSLayoutConstraint? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabel.sizeToFit()
        
        avatarImageView.image = UIImage(named: "Icon_1024.png")
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
        post.user.fetchInBackgroundWithBlock { (result, error) -> Void in
            let user = result as User
            
            if error == nil {
                if user.objectForKey("avatar") != nil {
                    self.avatarImageView.file = user.avatar
                    self.avatarImageView.loadInBackground(nil)
                }
            }
        }
    }

}
