//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timeSinceCreated: String?
    
    var retweetCount = 0
    var favCount = 0
    
    var id: NSNumber?
    var favorited = false
    var retweeted = false
    
    var imageUrl: NSURL?
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        id = dictionary["id"] as? NSNumber
        favorited = dictionary["favorited"] as! Bool
        retweeted = dictionary["retweeted"] as! Bool
        
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAtString = dictionary["created_at"] as? String
        if let createdAtString = createdAtString {
            createdAt = formatter.dateFromString(createdAtString)
        }
        
        let elapsedTime = NSDate().timeIntervalSinceDate(createdAt!)
        if elapsedTime < 60 {
            timeSinceCreated = String(Int(elapsedTime)) + "s"
        } else if elapsedTime < 3600 {
            timeSinceCreated = String(Int(elapsedTime / 60)) + "m"
        } else if elapsedTime < 24*3600 {
            timeSinceCreated = String(Int(elapsedTime / 60 / 60)) + "h"
        } else {
            timeSinceCreated = String(Int(elapsedTime / 60 / 60 / 24)) + "d"
        }
        
        //         
        if let media = dictionary["extended_entities"]?["media"] as? [NSDictionary] {
            //print("Media: \(media)")
            if let urlString = media[0]["media_url_https"] as? String {
                imageUrl = NSURL(string: urlString)
            }
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
