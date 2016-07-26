//
//  NewTweetViewController.swift
//  TwitterDemo
//
//  Created by Hien Quang Tran on 7/23/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate{
    optional func newTweetViewController(newTweetViewController: NewTweetViewController, didPostOrReplyTweet tweet: Tweet)
    
}

class NewTweetViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var replyToLabel: UILabel!
    @IBOutlet weak var replyButtonJustForShow: UIButton!
    
    @IBOutlet weak var limitCharatersLabel: UILabel!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    var tweet: Tweet!
    
    var textViewPlaceHolder: String!
    
    var isNewTweet = true {
        didSet {
            if let screenName = tweet.user?.screenName {
                textViewPlaceHolder = isNewTweet ? "" : "@" + screenName + " "
            }
        }
    }
    
    var limitCharaters = 140
    
    weak var delegate: NewTweetViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextView.becomeFirstResponder()
        tweetTextView.text = textViewPlaceHolder
        
        //setup view for newtweet/reply tweet
        setupView()
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MARK: - Actions
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tweetTapped(sender: UIBarButtonItem) {
        if isNewTweet {
            TwitterClient.sharedInstance.postStatusUpdate(tweetTextView.text, success: {(dictionary: NSDictionary) in
                print("Finally I have managed to post on the god damn wall")
            
                //get new tweet back from the server
                self.tweet = Tweet(dictionary: dictionary)
                //print("-------------------------------\n\(dictionary)\n-----------------------------------")
                self.delegate?.newTweetViewController!(self, didPostOrReplyTweet: self.tweet)
                self.dismissViewControllerAnimated(true, completion: nil)
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance.replyATweet(tweetTextView.text, originalId: tweet.id!, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.delegate?.newTweetViewController!(self, didPostOrReplyTweet: self.tweet)
                self.dismissViewControllerAnimated(true, completion: nil)
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
            
        }
    }

    //MARK: - Helpers
    func setupView() {
        if isNewTweet {
            replyToLabel.hidden = true
            replyButtonJustForShow.hidden = true
        } else {
            if let screenName = tweet.user?.screenName {
                replyToLabel.text = "Reply to @" + screenName
            }
        }
        
        limitCharatersLabel.text = "\(limitCharaters)"
    }

}
