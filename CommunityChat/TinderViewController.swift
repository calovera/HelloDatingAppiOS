//
//  TinderViewController.swift
//  Tinder
//
//  Created by Rob Percival on 17/10/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit

struct MyVariables {
    static var matches = 1
}

class TinderViewController: UIViewController {
    var imageFB:UIImage!
    var test:CGFloat = 0
    var xFromCenter: CGFloat = 0
    var label = UIView()
    @IBOutlet weak var myMatch: UIImageView!
    var usernames = [String]()
    var userImages = [NSData]()
    var currentUser = 0
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userImage2: UIImageView!
    
    @IBOutlet weak var leftButton:UIBarButtonItem!
    @IBOutlet weak var rightButton:UIBarButtonItem!
    
    
    

    
    @IBAction func cancel(sender: AnyObject) {
        PFUser.currentUser().addUniqueObject(self.usernames[self.currentUser], forKey:"rejected")
        PFUser.currentUser().save()
       
        
        
        self.currentUser++
        label.removeFromSuperview()
        if self.currentUser < self.userImages.count {
            
            var userImage: UIImageView = UIImageView(frame: CGRectMake(self.view.frame.width/4, self.view.frame.height/4.35, self.view.frame.width/2, self.view.frame.height/2.8))
            if self.userImages.count > 0 {
                userImage.image = UIImage(data: self.userImages[0])
            }
            userImage.contentMode = UIViewContentMode.ScaleAspectFill
            self.view.addSubview(userImage)
            
            var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
            userImage.addGestureRecognizer(gesture)
            
            userImage.userInteractionEnabled = true
            
            xFromCenter = 0
            xFromCenter = 0
            
        } else {
            var userImage2: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
            userImage2.image = UIImage(named: "s.png")
            userImage2.contentMode = UIViewContentMode.ScaleAspectFit
            self.view.addSubview(userImage2)
            println("No more users")
            
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated);
        let leftMenuViewController = self.revealViewController().rearViewController as? LeftMenuViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = UIColor(red: 230 / 255, green: 40 / 255, blue: 42 / 255, alpha: 1)
       // navigationController?.navigationBar.barTintColor = navBarColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        let navBarImage = UIImage(named: "sda.png")
        
        
        navigationItem.titleView = UIImageView(image: navBarImage)

        
        if self.revealViewController() != nil {
            self.leftButton.target = self.revealViewController()
            self.leftButton.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            //action for Right Swipe
            self.rightButton.target = self.revealViewController();
            self.rightButton.action = "rightRevealToggle:";
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.revealViewController().rightViewRevealOverdraw = 0.0
            self.revealViewController().rearViewRevealOverdraw = 0.0
        }
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
            if error == nil {
                
                println(geopoint)
                
                var user = PFUser.currentUser()
                
                user["location"] = geopoint
                
                // Create a query for places
                var query = PFUser.query()
                // Interested in locations near user.
                query.whereKey("location", nearGeoPoint:geopoint)

                // Limit what could be a lot of points.
                query.limit = 10
                
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                
                    var accepted = [String]()
                    var rejected = [String]()
                    
                    if PFUser.currentUser()["accepted"] != nil {
                         accepted = PFUser.currentUser()["accepted"] as! [String]
                    }
                    
                    if PFUser.currentUser()["rejected"] != nil {
                         rejected = PFUser.currentUser()["rejected"] as! [String]
                    }
                    
                    
                    
                    for user in users {
                        println(user)
                        var gender1 = user["gender"] as? NSString
                        var gender2 = PFUser.currentUser()["interestedIn"] as? NSString
                        
                        if gender1 == gender2 && PFUser.currentUser().username != user.username && !contains(accepted, user.username) && !contains(rejected, user.username) {
                            
                            self.usernames.append(user.username)
                            self.userImages.append(user["image"] as! NSData)
                        }
                        
                    } // end of the for loop
                    
                   
//                     var userImage2: UIImageView = UIImageView(frame: CGRectMake(self.view.frame.width/7.5, self.view.frame.height/9, self.view.frame.width/1.4, self.view.frame.height/1.5))
//                    userImage2.image = UIImage(named: "home-profile-bg@2x.png")
//                    userImage2.contentMode = UIViewContentMode.ScaleAspectFit
//                    self.view.addSubview(userImage2)
                    
                    
                    
                    var userImage: UIImageView = UIImageView(frame: CGRectMake(self.view.frame.width/4, self.view.frame.height/4.35, self.view.frame.width/2, self.view.frame.height/2.8))
                    if self.userImages.count > 0 {
                        userImage.image = UIImage(data: self.userImages[0])
                    }
                    userImage.contentMode = UIViewContentMode.ScaleAspectFill
                    self.view.addSubview(userImage)
                    
                    var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                                       userImage.addGestureRecognizer(gesture)
               
                    userImage.userInteractionEnabled = true
                    
                    
                    
                    
                })
                
                //user.save()
                
            }
            
        } // end of geopoint

        
    }

    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        
        let translation = gesture.translationInView(self.view)
        label = gesture.view!
        
        xFromCenter += translation.x
        
        var scale = min(100 / abs(xFromCenter), 1)
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if label.center.x < 100 {
                
                println("Not Chosen")
                label.removeFromSuperview()
                if self.currentUser < self.userImages.count {
                PFUser.currentUser().addUniqueObject(self.usernames[self.currentUser], forKey:"rejected")
                PFUser.currentUser().save()
                
                self.currentUser++
                }
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                println("Chosen")
                label.removeFromSuperview()
                if self.currentUser >= self.userImages.count {
                    var userImage2: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                    userImage2.image = UIImage(named: "s.png")
                    userImage2.contentMode = UIViewContentMode.ScaleAspectFit
                    self.view.addSubview(userImage2)
                }
                if self.currentUser < self.userImages.count {
                PFUser.currentUser().addUniqueObject(self.usernames[self.currentUser], forKey:"accepted")
                PFUser.currentUser().save()
                
                self.currentUser++
                }
                
                // Here for isAMatch
                
                    let query = PFUser.query()
                    query.whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
                    query.whereKey("accepted", equalTo: PFUser.currentUser().username)
                    query.whereKey("username", containedIn: PFUser.currentUser()["accepted"] as! [AnyObject])
                    
                println(query.countObjects())
                    
                if query.countObjects() == MyVariables.matches {
                    
                    MyVariables.matches++
                    self.performSegueWithIdentifier("matching", sender: self)
                }
                    
                
                    
                label.removeFromSuperview()
                    
                    
                
                
            }
            
            
            
            label.removeFromSuperview()
            if self.currentUser >= self.userImages.count {
                var userImage2: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                userImage2.image = UIImage(named: "s.png")
                userImage2.contentMode = UIViewContentMode.ScaleAspectFit
                self.view.addSubview(userImage2)
            }
            if self.currentUser < self.userImages.count {
                
                var userImage: UIImageView = UIImageView(frame: CGRectMake(self.view.frame.width/4, self.view.frame.height/4.35, self.view.frame.width/2, self.view.frame.height/2.8))
                if self.userImages.count > 0 {
                    
                
                userImage.image = UIImage(data: self.userImages[self.currentUser])
                }
                userImage.contentMode = UIViewContentMode.ScaleAspectFit
                self.view.addSubview(userImage)
                
                var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                userImage.addGestureRecognizer(gesture)
                
                userImage.userInteractionEnabled = true
                
                xFromCenter = 0
                xFromCenter = 0
                
            } else {
                                     var userImage2: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                                    userImage2.image = UIImage(named: "s.png")
                                    userImage2.contentMode = UIViewContentMode.ScaleAspectFit
                                    self.view.addSubview(userImage2)
                println("No more users")
                
            }
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    
    
    
    
    
    
    
    
    //////////////////////////////////////////////---> This is not needed <------///////////////////////////////////////
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


/*        func addPerson(urlString:String) {

var newUser = PFUser()

let url = NSURL(string: urlString)

// Update - changed url to url!

let urlRequest = NSURLRequest(URL: url!)

NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
response, data, error in

newUser["image"] = data

newUser["gender"] = "female"

var lat = Double(37 + i)

var lon = Double(-122 + i)

i = i + 10

var location = PFGeoPoint(latitude: lat, longitude: lon)

newUser["location"] = location

newUser.username = "\(i)"

newUser.password = "password"

newUser.signUp()


})




}

addPerson("http://s3.amazonaws.com/readers/2010/12/07/3186885154021fda16b1_1.jpg")

/*
http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=44643840
http://static.comicvine.com/uploads/square_small/0/2617/103863-63963-torongo-leela.JPG
http://i263.photobucket.com/albums/ii139/whatgloom/janejetson.jpg
http://www.scrapwallpaper.com/wp-content/uploads/2014/08/female-cartoon-characters-pictures-6.jpg
http://diaryofalagosmumblog.files.wordpress.com/2011/11/smurfette-scaled500.gif
*/

}*/
