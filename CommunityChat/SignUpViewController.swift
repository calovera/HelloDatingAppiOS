//
//  SignUpViewController.swift
//  Tinder
//
//  Created by Rob Percival on 17/10/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    var imageFB:UIImage!
    
    @IBOutlet var sliderValue: UISlider!
    

    
    @IBOutlet weak var kms2: UILabel!
    @IBOutlet weak var kms: UILabel!
    
    @IBAction func sliderMoved(sender: AnyObject) {
        let timesTable = Int(sliderValue.value * 50)
        if timesTable < 2 {
            kms.text = String(1)
            kms2.text = "Km"
        } else {
            kms.text = String(timesTable)
            kms2.text = "Kms"
        }
    }
    
    @IBOutlet var genderSwitch: UISwitch!
    
    @IBAction func signUp(sender: AnyObject) {
        
        var user = PFUser.currentUser()
        
        if genderSwitch.on {
            
            user["interestedIn"]="female"
            
        } else {
            
            user["interestedIn"]="male"
            
        }
        
        user.save()
        self.performSegueWithIdentifier("signedUp", sender: self)
        
    }
    
    @IBOutlet var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = UIColor(red: 230 / 255, green: 40 / 255, blue: 42 / 255, alpha: 1)
        // navigationController?.navigationBar.barTintColor = navBarColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        let navBarImage = UIImage(named: "sda.png")
        
        
        navigationItem.titleView = UIImageView(image: navBarImage)
        var user = PFUser.currentUser()
        
        var FBSession = PFFacebookUtils.session()
        
        var accessToken = FBSession.accessTokenData.accessToken
        
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let image = UIImage(data: data)
            
            
            
            self.profilePic.image = image
            self.profilePic.image = image
            self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
            self.profilePic.clipsToBounds = true;
            self.profilePic.layer.borderWidth = 3.0
            self.profilePic.layer.borderColor = UIColor.whiteColor().CGColor
            
            self.imageFB = image
            
            user["image"] = data
            
            user.save()
            
            FBRequestConnection.startForMeWithCompletionHandler({
                connection, result, error in
                user["name"] = "default"
                user["gender"] = result["gender"]
                user["name"] = result["name"]
               user["email"] = result["email"]
                
                user.save()
                
                println(result)
                
                
            })
            
        })
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "signedUp"{
            let tinderViewController = segue.destinationViewController as? TinderViewController;
            tinderViewController?.loadView()
            tinderViewController?.imageFB = self.imageFB
            tinderViewController?.test = 10
            
        }
    }
}
