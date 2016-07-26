//
//  TweetCellTableViewCell.swift
//  TwitterDemo
//
//  Created by Hien Quang Tran on 7/23/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstaint: NSLayoutConstraint!
    
    var tweet: Tweet! {
        didSet{
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@" + (tweet.user?.screenName)!
            contentLabel.text = tweet.text
            timeStampLabel.text = tweet.timeSinceCreated
            
            if tweet.retweetCount == 0 {
                retweetCountLabel.hidden = true
            } else {
                retweetCountLabel.hidden = false
                retweetCountLabel.text = "\(tweet.retweetCount)"
            }
            
            if tweet.favCount == 0 {
                likeCountLabel.hidden = true
            } else {
                likeCountLabel.hidden = false
                likeCountLabel.text = "\(tweet.favCount)"
            }
            
            
            if let profileImageUrl = tweet.user?.profileImageUrl {
                profileImageView.setImageWithURL(profileImageUrl)
            } else {
                profileImageView.image = UIImage(named: "noPhoto")
            }
            
            
            //set color for like button
            if tweet.favorited{
                likeButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
            } else {
                likeButton.setImage(UIImage(named: "like-action"), forState: .Normal)
            }
            
            //set color for retweet button
            if tweet.retweeted{
                retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
            } else {
                retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
            }
            
            //if the image exists :D
            if tweet.imageUrlString != "" {
                imageViewHeightConstaint.constant = 200
                tweetImageView.hidden = false
                let imageRequest = NSURLRequest(URL: NSURL(string: tweet.imageUrlString)!)
                tweetImageView.setImageWithURLRequest(imageRequest, placeholderImage: UIImage(named: "noPhoto"), success: { (imageRequest, imageResponse, image) -> Void in
                    
                        if imageResponse != nil {
                            self.tweetImageView.alpha = 0.0
                            self.tweetImageView.image = image
                            UIView.animateWithDuration(0.5, animations: { () -> Void in
                                self.tweetImageView.alpha = 1.0
                            })
                        } else {
                            self.tweetImageView.image = image
                        }
                    },
                    failure: { (imageRequest, imageResponse, error) -> Void in
                        print(error.localizedDescription)
                })
            } else { //if image doesn;t exist then hide it
                imageViewHeightConstaint.constant = 0
                tweetImageView.hidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 10
        profileImageView.layer.masksToBounds =  true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - Actions
    @IBAction func retweetButtonTapped(sender: UIButton) {
        //if this tweet is already tweeted
        if tweet.retweeted {
            //then unretweet it
            TwitterClient.sharedInstance.getRetweetedId(tweet.id!, success: { retweetedId in
                if let id = retweetedId {
                    TwitterClient.sharedInstance.retweet(id as! NSNumber, success: { response in
                        if response != nil {
                            print("I just un-retweet")
                        }
                        }, failure: { error in
                            print(error.localizedDescription)
                    })
                }
                }, failure: { error in
                    print(error.localizedDescription)
            })
            self.tweet.retweetCount -= 1
            self.retweetCountLabel.text =  "\(self.tweet.retweetCount)"
            self.tweet.retweeted = false
            updateReTweetButton()
        } else {
            //otherwise retweet it
            retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
            TwitterClient.sharedInstance.retweet(tweet.id!, success: { response in
                if response != nil {
                    print("I just retweet")
                }
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
            self.tweet.retweetCount += 1
            self.retweetCountLabel.text =  "\(self.tweet.retweetCount)"
            self.tweet.retweeted = true
            updateReTweetButton()
        }
    }
    
    @IBAction func likeButtonTapped(sender: UIButton) {
        //if this tweet is already liked
        if tweet.favorited {
            //then unlike it
            TwitterClient.sharedInstance.unlikeATweet(tweet.id!, success: { (response: AnyObject?) in
                if response != nil {
                    print("I just unlike a tweet")
                }
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
            self.tweet.favCount -= 1
            self.likeCountLabel.text = "\(self.tweet.favCount)"
            self.tweet.favorited = false
            updateLikeButton()
        } else {
            //otherwise like it
            TwitterClient.sharedInstance.likeATweet(tweet.id!, success: { (response: AnyObject?) in
                if response != nil {
                    print("I just like a tweet")
                }
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
            self.tweet.favCount += 1
            self.likeCountLabel.text = "\(self.tweet.favCount)"
            self.tweet.favorited = true
            updateLikeButton()
        }
    }
    
    
    //MARK: - Helpers
    func updateLikeButton(){
        let imageName = tweet.favorited ? "like-action-on" : "like-action"
        likeButton.setImage(UIImage(named: imageName), forState: .Normal)
        likeButton.alpha = 0.0
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: [], animations: {
            self.likeButton.alpha = 1.0
            }, completion: nil)
    }
    
    func updateReTweetButton() {
        let imageName = tweet.retweeted ? "retweet-action-on" : "retweet-action"
        retweetButton.setImage(UIImage(named: imageName), forState: .Normal)
        retweetButton.alpha = 0.0
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: [], animations: {
            self.retweetButton.alpha = 1.0
            }, completion: nil)    }
}
