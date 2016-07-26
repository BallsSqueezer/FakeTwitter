//
//  HomeViewController.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, NewTweetViewControllerDelegate, TweetDetailViewControllerDelegate{
    @IBOutlet weak var newTweetFloatingButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //set logo to the navigation bar
        let logoImage = UIImage(named: "Twitter_logo_white")
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        logoImageView.image = logoImage
        self.navigationItem.titleView = logoImageView
        
        //gradient color for button
        newTweetFloatingButton.layer.backgroundColor = AppThemes.themeColor.CGColor
        
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
            newTweetViewController.isNewTweet = true
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
    func newTweetViewController(newTweetViewController: NewTweetViewController, didPostOrReplyTweet tweet: Tweet) {
        tweets.insert(tweet, atIndex: 0)
        tableView.reloadData()
    }
    
    func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, didUpdateTweet tweet: Tweet, atIndexPath indexPath: NSIndexPath) {
        self.tweets[indexPath.row] = tweet
        tableView.reloadData()
    }
    
    //MARK: - Helpers
    func getHomeTimeline() {
        TwitterClient.sharedInstance.homeTimeline(nil, success: { (tweets: [Tweet]) in
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
    
    func loadMoreData() {
        if let noNiTweets = tweets {
            let maxId = noNiTweets.last?.id
            TwitterClient.sharedInstance.homeTimeline(maxId, success: { (tweets: [Tweet]) in
                self.tweets.appendContentsOf(tweets)
                self.tableView.reloadData()
                self.isMoreDataLoading = false
                self.loadingMoreView?.stopAnimating()
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        }
        
    }
    
    func setupLoadingIndicator() {
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
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

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading){
            // Calculate the position of scrollview where the date shoule start loading
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollViewOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollViewOffsetThreshold && tableView.dragging{
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                if loadingMoreView != nil {
                    loadingMoreView?.frame = frame
                    loadingMoreView!.startAnimating()
                }
                //load more results
                loadMoreData()
            }
        }
    }
}


