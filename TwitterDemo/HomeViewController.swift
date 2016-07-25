//
//  HomeViewController.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, NewTweetViewControllerDelegate, TweetDetailViewControllerDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getHomeTimeline()
        
        //Pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
         tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
     // MARK: - Navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        
        if segue.identifier == "newTweetSegue"{
            let newTweetViewController = navigationController.topViewController as! NewTweetViewController
            newTweetViewController.delegate = self
        } else if segue.identifier == "tweetDetailSegue" {
            let detailViewController = navigationController.topViewController as! TweetDetailViewController
            detailViewController.delegate = self
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                detailViewController.tweet = tweets[indexPath.row]
                detailViewController.indexPath = indexPath
            }
        }
     }
    
    //MARK: - NewTweetViewControllerDelegate, TweetDetailViewControllerDelegate
    func newTweetViewController(newTweetViewController: NewTweetViewController, didPostNewTweet tweet: Tweet) {
        tweets.insert(tweet, atIndex: 0)
        tableView.reloadData()
    }
    
    func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, didUpdateTweet tweet: Tweet, atIndexPath indexPath: NSIndexPath?, withReplyTweet replyTweet: Tweet?) {
        self.tweets[(indexPath?.row)!] = tweet
        tableView.reloadData()
    }
    
    //MARK: - Helpers
    func getHomeTimeline() {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getHomeTimeline()
        refreshControl.endRefreshing()        
    }
    
    //MARK: - Actions
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


