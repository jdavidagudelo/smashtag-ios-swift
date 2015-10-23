//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Ingenieria y Software on 22/10/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var labelUserName: UILabel!
    
    @IBOutlet weak var labelTweetBody: UILabel!
    
    @IBOutlet weak var imageViewUser: UIImageView!
    
    var tweet: Tweet? {
        didSet{
            updateUI()
        }
    }
    private func loadImage(url url: NSURL?)
    {
        if let profileImageURL = url
        {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)){
                () -> Void in
                if let imageData = NSData(contentsOfURL: profileImageURL)
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        () -> Void in
                        self.imageViewUser?.image = UIImage(data: imageData)
                    }
                }
        
            }
        }
    }
    func updateUI(){
        if let tweet = self.tweet
        {
            labelTweetBody?.text = tweet.text
            if labelTweetBody?.text != nil{
                for _ in tweet.media{
                    
                }
            }
            labelUserName?.text = "\(tweet.user.name)"
            loadImage(url: tweet.user.profileImageURL)
        }
    }
}
