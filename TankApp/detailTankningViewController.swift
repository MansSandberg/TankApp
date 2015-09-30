//
//  detailTankningViewController.swift
//  TankApp
//
//  Created by Måns Sandberg on 2015-01-15.
//  Copyright (c) 2015 Måns Sandberg. All rights reserved.
//

import UIKit
import CoreData
import iAd
import AdSupport

class detailTankningViewController: UIViewController, ADBannerViewDelegate {
    
    var bannerView:ADBannerView?

    
    @IBOutlet var textLabelLiter: UILabel!
    
    @IBOutlet var textLabelKronor: UILabel!
    
    @IBOutlet var textLabelLiterpris: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    
    
    func editAlert() {
        let alertController = UIAlertController(title: "Det här är inte klart, än...", message:
            "Om du lugnar dig lite så ska du se att den här funktionen snart fungerar.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func edit(sender: AnyObject) {
        editAlert()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.bannerView?.hidden = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.bannerView?.hidden = true
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
