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
    
    //get home timeline
    func homeTimeline(success: [Tweet] -> (), failure: NSError -> ()){
        GET(PublicApi.getHomeTimeline, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })

    }
    
    //get user acount
    func currentAccount(){
        GET(PublicApi.getAccountVerifyCredential, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            print("screenName: \(user.screenName!)")
        
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("\(error.localizedDescription)")
        })
    }
    
    //Poist new tweet
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
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            print("I got access token = \(accessToken.token)")
            
            self.loginSuccess?()
            
        }) { (error: NSError!) in
            print("\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    struct PublicApi {
        static let getHomeTimeline = "1.1/statuses/home_timeline.json"
        static let getAccountVerifyCredential = "1.1/account/verify_credentials.json"
        static let postStatusUpdate = "1.1/statuses/update.json"
    }


}
