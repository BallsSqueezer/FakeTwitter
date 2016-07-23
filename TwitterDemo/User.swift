//
//  User.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: NSURL?
    var tagline: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary //store user data in a dictionary to save current user as json
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        let profileImageURLString = dictionary["profile_image_url_https"] as? String
        if let profileImageURLString = profileImageURLString {
            profileImageUrl = NSURL(string: profileImageURLString)!
        }
    }
    
//    static var _currentUser: User?
//    
//    class var currentUser: User? {
//        get {
//            //if there is no current user, check if there is any in the data
//            if _currentUser == nil {
//                let defaults = NSUserDefaults.standardUserDefaults()
//                let userData = defaults.objectForKey("currentUserData") as? NSData
//            
//                //if there is, store them in to _currentUser
//                if let userData = userData{
//                    let dictionary =  try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
//                
//                    _currentUser = User(dictionary: dictionary)
//                }
//            }
//            
//            return _currentUser
//        }
//        
//        set(user) {
//            _currentUser = user
//            
//            let defaults = NSUserDefaults.standardUserDefaults()
//            
//            //save user data as a dictionary to json format
//            if let user = user {
//                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
//                
//                defaults.setObject(data, forKey: "currentUserData")
//            } else {
//                defaults.setObject(nil, forKey: "currentUserData")
//            }
//            
//            defaults.synchronize()
//        }
//    }
}
