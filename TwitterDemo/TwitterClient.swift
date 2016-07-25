//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Hien Quang Tran on 7/23/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "HfvLpXFzLW03rfgmYtN8aYBzd", consumerSecret: "7WxVtEVOoAT9ABwJQtNVvgOZTUVLQB8FJ1g85lZLARHQNPMFFX")
    
    //MARK: - Get home timeline
    func homeTimeline(success: [Tweet] -> (), failure: NSError -> ()){
        GET(PublicApi.getHomeTimeline, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })

    }
    
    //MARK: - Get user acount
    func currentAccount(success: User -> (), failure: NSError -> ()){
        GET(PublicApi.getAccountVerifyCredential, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
        
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("\(error.localizedDescription)")
                failure(error)
        })
    }
    
    //MARK: - Poist new tweet
    func postStatusUpdate(status: String, success: NSDictionary -> (), failure: NSError -> ()) {
        var parameter = [String: String]()
        parameter["status"] = status
        
        POST(PublicApi.postStatusUpdate, parameters: parameter, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("Fuck yeah, I've update my status")
            let dictionary = response as! NSDictionary
            success(dictionary)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print(error.localizedDescription)
                failure(error)
        })
        
        
    }
    
    //MARK: - Like/unlike a tweet
    func likeATweet(id: NSNumber, success: AnyObject? -> (), failure:NSError -> ()) {
        var params = [String : AnyObject]()
        params["id"] = id
        POST(PublicApi.likeATweet, parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success(response!)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print(error.localizedDescription)
            failure(error)
        }
    }

    func unlikeATweet(id: NSNumber, success: AnyObject? -> (), failure:NSError -> ()) {
        var params = [String : AnyObject]()
        params["id"] = id
        POST(PublicApi.unlikeATweet, parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success(response!)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    //MARK: - Retweet/un-retweet
    func retweet(id: NSNumber, success: AnyObject? -> (), failure: NSError -> ()){
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success (response!)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func unRetweet(id: NSNumber, success: AnyObject? -> (), failure: NSError -> ()){
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success (response!)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    // Get  retweet ID
    func getRetweetedId(id: NSNumber, success: AnyObject? -> (), failure:(NSError) -> ()) {
        
        var params = [String : AnyObject]()
        params["include_my_retweet"] = true
        GET("1.1/statuses/show/\(id).json", parameters: params, progress: nil, success: { (task:NSURLSessionDataTask, response: AnyObject?) in
            let tweet = response as! NSDictionary
            let currentUserRetweet = tweet["current_user_retweet"] as! NSDictionary
            let retweetedId = currentUserRetweet["id"] as? NSNumber
            success(retweetedId)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print(error)
            failure(error)
        }
    }
    
    //MARK: - Handle login
    func login(success: () -> () ,failure: NSError -> () ){
        loginSuccess = success
        loginFailure = failure
        
        // To make sure whoever login before, logout first
        let client = TwitterClient.sharedInstance
        client.deauthorize()
        
        client.fetchRequestTokenWithPath("oauth/request_token", method: "POST", callbackURL: NSURL(string: "BallSquEezer://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
        
        print("I got request token = \(requestToken.token)")
        
        // TODO: redirect to authrization url
        let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
        UIApplication.sharedApplication().openURL(authUrl)
        
        }) { (error: NSError!) in
            print("\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        //
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            print("I got access token = \(accessToken.token)")
            
            self.currentAccount({ (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })
        }) { (error: NSError!) in
            print("\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    struct PublicApi {
        static let getHomeTimeline = "1.1/statuses/home_timeline.json"
        static let getAccountVerifyCredential = "1.1/account/verify_credentials.json"
        static let postStatusUpdate = "1.1/statuses/update.json"
        static let likeATweet = "1.1/favorites/create.json"
        static let unlikeATweet = "1.1/favorites/destroy.json"
    }


}
