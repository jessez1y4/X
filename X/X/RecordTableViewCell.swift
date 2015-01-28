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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
