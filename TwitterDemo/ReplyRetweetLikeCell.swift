//
//  ReplyRetweetLikeCell.swift
//  TwitterDemo
//
//  Created by Hien Quang Tran on 7/24/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class ReplyRetweetLikeCell: UITableViewCell {

    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
