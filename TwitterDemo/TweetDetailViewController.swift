//
//  TweetDetailViewController.swift
//  TwitterDemo
//
//  Created by Hien Quang Tran on 7/24/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

protocol TweetDetailViewControllerDelegate: class {
    func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, didUpdateTweet tweet: Tweet, atIndexPath indexPath: NSIndexPath?, withReplyTweet replyTweet: Tweet?)
}

class TweetDetailViewController: UIViewController {
    //MARK: - Outlets and Variables
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var createAtLabel: UILabel!
    
    @IBOutlet weak var retweetsCountLabel: UILabel!
    
    @IBOutlet weak var likesCountLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    
    var tweet: Tweet!
    
    weak var delegate: TweetDetailViewControllerDelegate?
    
    var indexPath: NSIndexPath!
    
    //MARK: Load views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpContent()
    }
    

    //MARK: - Actions
    @IBAction func backBarButtonTapped(sender: UIBarButtonItem) {
        delegate?.tweetDetailViewController(self, didUpdateTweet: tweet, atIndexPath: indexPath, withReplyTweet: nil)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func replyButtonTapped(sender: UIButton) {
    }
    
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
            self.retweetsCountLabel.text =  "\(self.tweet.retweetCount)"
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
            self.retweetsCountLabel.text =  "\(self.tweet.retweetCount)"
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
            self.likesCountLabel.text = "\(self.tweet.favCount)"
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
            self.likesCountLabel.text = "\(self.tweet.favCount)"
            self.tweet.favorited = true
            updateLikeButton()
        }
    }
    
    //MARK: - Helpers
    func setUpContent() {
        nameLabel.text = tweet.user?.name
        screenNameLabel.text = "@" + (tweet.user?.screenName)!
        contentLabel.text = tweet.text
        
        //profile image
        if let profileImageUrl = tweet.user?.profileImageUrl {
            profileImageView.setImageWithURL(profileImageUrl)
        } else {
            profileImageView.image = UIImage(named: "noPhoto")
        }
        
        //time posted
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd/MM/yyyy, hh:mm"
        createAtLabel.text = "\(dateFormatter.stringFromDate(tweet.createdAt!))"
        
        retweetsCountLabel.text = "\(tweet.retweetCount)"
        likesCountLabel.text = "\(tweet.favCount)"
        
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

