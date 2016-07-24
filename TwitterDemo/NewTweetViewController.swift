//
//  NewTweetViewController.swift
//  TwitterDemo
//
//  Created by Hien Quang Tran on 7/23/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate{
    optional func newTweetViewController(newTweetViewController: NewTweetViewController, didPostNewTweet tweet: Tweet)
    
}

class NewTweetViewController: UIViewController {
    @IBOutlet weak var tweetTextView: UITextView!
    
    var tweet: Tweet!
    
    weak var delegate: NewTweetViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tweetTapped(sender: UIBarButtonItem) {
        
        TwitterClient.sharedInstance.postStatusUpdate(tweetTextView.text, success: {(dictionary: NSDictionary) in
            print("Finally I have my post printed on the god damn wall")
            
            //get new tweet back from the server
            self.tweet = Tweet(dictionary: dictionary)
            //print("-------------------------------\n\(dictionary)\n-----------------------------------")
            self.delegate?.newTweetViewController!(self, didPostNewTweet: self.tweet)
            self.dismissViewControllerAnimated(true, completion: nil)
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
