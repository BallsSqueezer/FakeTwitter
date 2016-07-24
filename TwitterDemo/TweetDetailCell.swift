//
//  TweetDetailCell.swift
//  TwitterDemo
//
//  Created by Hien Quang Tran on 7/24/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class TweetDetailCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var createAtLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@" + (tweet.user?.screenName)!
            contentLabel.text = tweet.text
            /*
            if tweet.retweetCount == 0 {
                retweetCountLabel.hidden = true
            } /*else if tweet.retweetCount > 10000{
                 let displayedCount = tweet.retweetCount / 1000
                 retweetCountLabel.hidden = false
                 retweetCountLabel.text = String(format: "%.1fK", displayedCount)
             }*/ else {
                retweetCountLabel.hidden = false
                retweetCountLabel.text = "\(tweet.retweetCount)"
            }
            
            print("likes: \(tweet.favCount)")
            if tweet.favCount == 0 {
                likeCountLabel.hidden = true
            } /*else if tweet.retweetCount > 10000{
                 let displayedCount = tweet.favCount / 1000
                 likeCountLabel.hidden = false
                 likeCountLabel.text = String(format: "%.1fK", displayedCount)
             } */else {
                likeCountLabel.hidden = false
                likeCountLabel.text = "\(tweet.favCount)"
            }*/
            
            
            if let profileImageUrl = tweet.user?.profileImageUrl {
                profileImageView.setImageWithURL(profileImageUrl)
            } else {
                profileImageView.image = UIImage(named: "noPhoto")
            }
            
            //"EEE dd MMM yyy hh:mm:ss +zzzz"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE, dd/MM/yyyy, hh:mm"
            createAtLabel.text = "\(dateFormatter.stringFromDate(tweet.createdAt!))"
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
