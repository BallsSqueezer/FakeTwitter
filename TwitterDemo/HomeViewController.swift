//
//  HomeViewController.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, NewTweetViewControllerDelegate, TweetCellDelegate  {
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
        if segue.identifier == "newTweetSegue"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = navigationController.topViewController as! NewTweetViewController
            newTweetViewController.delegate = self
        } else if segue.identifier == "tweetDetailSegue" {
            let detailViewController = segue.destinationViewController as! TweetDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailViewController.tweet = tweets[indexPath.row]
            }
        }
     }
    
    //MARK: - NewTweetViewControllerDelegate, TweetCellDelegate
    func newTweetViewController(newTweetViewController: NewTweetViewController, didPostNewTweet tweet: Tweet) {
        tweets.insert(tweet, atIndex: 0)
        tableView.reloadData()
    }
//    
//    func tweetCell(tweetCell: TweetCell, didUpdateFavoriteCount tweet: Tweet, atRow row: Int) {
//        tweets[row] = tweet
//        tableView.reloadData()
//    }
//    
//    func tweetCell(tweetCell: TweetCell, didUpdateRetweetCount tweet: Tweet) {
//        tweets.insert(tweet, atIndex: 0)
//        tableView.reloadData()
//    }
    
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
        cell.indexPath = indexPath
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


