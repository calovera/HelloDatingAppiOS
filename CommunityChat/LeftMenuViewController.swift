//
//  LeftMenuViewController.swift
//  CommunityChat
//
//  Created by nmhoang on 5/27/15.
//  Copyright (c) 2015 Training. All rights reserved.
//

import Foundation

class LeftMenuViewController: UIViewController
{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var fbImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logOut", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFUser.currentUser()
        
        var FBSession = PFFacebookUtils.session()
        
        var accessToken = FBSession.accessTokenData.accessToken
        
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let image = UIImage(data: data)
            
            self.fbImageView.image = image
            
            user["image"] = data
            
            user.save()
            
            FBRequestConnection.startForMeWithCompletionHandler({
                connection, result, error in
                
                user["gender"] = result["gender"]
                user["name"] = result["name"]
                user["email"] = result["email"]
                
                user.save()
                
                println(result)
                
                self.nameLabel.text = result.name
                
                self.activityIndicator.hidden = true
                self.activityIndicator.removeFromSuperview()
            })
            
        })
    }
}
