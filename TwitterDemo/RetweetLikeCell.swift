//
//  RetweetLikeCell.swift
//  TwitterDemo
//
//  Created by Hien Quang Tran on 7/24/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class RetweetLikeCell: UITableViewCell {
    
    @IBOutlet weak var retweetsCountLabel: UILabel!
    
    @IBOutlet weak var likesCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            retweetsCountLabel.text = "\(tweet.retweetCount)"
            likesCountLabel.text = "\(tweet.favCount)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
