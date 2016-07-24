//
//  TweetCellTableViewCell.swift
//  TwitterDemo
//
//  Created by Hien Quang Tran on 7/23/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    optional func tweetCell(tweetCell: TweetCell, didUpdateFavoriteCount tweet: Tweet, atRow row: Int)
    
    optional func tweetCell(tweetCell: TweetCell, didUpdateRetweetCount tweet: Tweet)
}

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
    
    weak var delegate: TweetCellDelegate?
    
    var indexPath: NSIndexPath!
    
    var tweet: Tweet! {
        didSet{
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@" + (tweet.user?.screenName)!
            contentLabel.text = tweet.text
            timeStampLabel.text = tweet.timeSinceCreated
            
            //print("retweet: \(tweet.retweetCount)")
            if tweet.retweetCount == 0 {
                retweetCountLabel.hidden = true
            } else {
                retweetCountLabel.hidden = false
                retweetCountLabel.text = "\(tweet.retweetCount)"
            }
            
            //print("likes: \(tweet.favCount)")
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
            retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
            TwitterClient.sharedInstance.unRetweet(tweet.id!, success: { (dictionary: NSDictionary) in
                print("I just un-retweet")
                self.tweet = Tweet(dictionary: dictionary)
                //self.delegate?.tweetCell!(self, didUpdateRetweetCount: self.tweet)
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        } else {
            //otherwise retweet it
            retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
            TwitterClient.sharedInstance.retweet(tweet.id!, success: { (dictionary: NSDictionary) in
                print("I just retweet")
                self.tweet = Tweet(dictionary: dictionary)
                //self.delegate?.tweetCell!(self, didUpdateRetweetCount: self.tweet)
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func likeButtonTapped(sender: UIButton) {
        //if this tweet is already liked
        if tweet.favorited {
            //then unlike it
            //likeButton.setImage(UIImage(named: "like-action"), forState: .Normal)
            TwitterClient.sharedInstance.unlikeATweet(tweet.id!, success: { (dictionary: NSDictionary) in
                print("I just unlike a tweet")
                self.tweet = Tweet(dictionary: dictionary)
                //self.delegate?.tweetCell!(self, didUpdateFavoriteCount: self.tweet, atRow: self.indexPath.row)
            }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        } else {
            //otherwise like it
            //likeButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
            TwitterClient.sharedInstance.likeATweet(tweet.id!, success: { (dictionary: NSDictionary) in
                print("I just like a tweet")
                self.tweet = Tweet(dictionary: dictionary)
                //self.delegate?.tweetCell!(self, didUpdateFavoriteCount: self.tweet, atRow: self.indexPath.row)
            }) { (error: NSError) in
                print(error.localizedDescription)
            }
        }
        
    }
}
