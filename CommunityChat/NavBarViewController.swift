//
//  NavBarViewController.swift
//  CommunityChat
//
//  Created by Carlos Lovera on 5/28/15.
//  Copyright (c) 2015 Training. All rights reserved.
//

import UIKit

class NavBarViewController: UIViewController {

    @IBAction func scanAgain(sender: AnyObject) {
         self.performSegueWithIdentifier("signedUp2", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = UIColor(red: 230 / 255, green: 40 / 255, blue: 42 / 255, alpha: 1)
        // navigationController?.navigationBar.barTintColor = navBarColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        let navBarImage = UIImage(named: "sda.png")
        
        
        navigationItem.titleView = UIImageView(image: navBarImage)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
