//
//  literViewController.swift
//  TankApp
//
//  Created by Måns Sandberg on 2015-01-17.
//  Copyright (c) 2015 Måns Sandberg. All rights reserved.
//

import UIKit
import iAd
import AdSupport

class literViewController: UIViewController, ADBannerViewDelegate {
    
    var bannerView:ADBannerView?

    
    
    @IBOutlet var textFeildKronor: UITextField!
    
    @IBOutlet var textFieldLiterpris: UITextField!
    
    @IBOutlet var textLabelLiter: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.view.endEditing(true);
//    }
    
    func roundFrac2(x: Double) -> Double {
        return round(x * 100) / 100
    }
    
    @IBAction func resultButton(sender: AnyObject) {
        
        var literpris = (textFieldLiterpris.text as NSString).doubleValue
        var kronor = (textFeildKronor.text as NSString).doubleValue
        var liter = roundFrac2((kronor / literpris))
        
        textLabelLiter.text = "Du har råd med \(liter) liter"
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.bannerView?.hidden = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.bannerView?.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
