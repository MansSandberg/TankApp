//
//  nyTankningiewController.swift
//  TankApp
//
//  Created by Måns Sandberg on 2015-01-11.
//  Copyright (c) 2015 Måns Sandberg. All rights reserved.
//

import UIKit
import CoreData
import iAd
import AdSupport
import CoreText

extension String {
    var converted: String {
        return fractionDigits()
    }
    var toDouble: Double {
        return NSNumberFormatter().numberFromString(self)!.doubleValue
    }
    var toFloat: Float {
        return NSNumberFormatter().numberFromString(self)!.floatValue
    }
    func fractionDigits(min:Int = 2, max:Int = 2)-> String {
        let styler = NSNumberFormatter()
        styler.minimumFractionDigits = min
        styler.maximumFractionDigits = max
        let converter = NSNumberFormatter()
        converter.decimalSeparator = "."
        if let result = converter.numberFromString(self) {
            return styler.stringFromNumber(result)!
        } else {
            converter.decimalSeparator = ","
            if let result = converter.numberFromString(self) {
                return styler.stringFromNumber(result)!
            }
        }
        return ""
    }
}


class nyTankningViewController: UIViewController, ADBannerViewDelegate, UITextFieldDelegate {
    
    var bannerView:ADBannerView?
    
    @IBOutlet var textFieldLiter: UITextField!
    @IBOutlet var textFieldKronor: UITextField!
    
    @IBOutlet var datePickerDatum: UIDatePicker!
    
    @IBOutlet var textLabelFyllI: UILabel!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //Edita befintlig tankning
    
    var liter: String! = ""
    var kronor: String! = ""
    var datum: String! = ""
    
    var existingDatum: NSDate!
    var existingTankning: NSManagedObject!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.canDisplayBannerAds = true
        self.bannerView?.delegate = self
        self.bannerView?.hidden = true
        textFieldLiter.delegate = self
        textFieldKronor.delegate = self

        // Do any additional setup after loading the view.
        
        if (existingTankning != nil) {
            
            textLabelFyllI.text! = ""
            textFieldLiter.text! = liter!
            textFieldKronor.text! = kronor!
            datePickerDatum.setDate(existingDatum, animated: true)
            navigationItem.title = "Redigera Tankning"
            
        }
        else {
            return
        }
    }
//    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.view.endEditing(true);
//    }
    
    func alertViewEmptyFields() {
        let alertController = UIAlertController(title: "Ojsan, du glömde något!", message:
            "Du msåte fylla i alla fält innan du sparar.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func roundFrac2(x: Double) -> Double {
        return round(x * 100) / 100
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func saveButton(sender: AnyObject) {
        if (textFieldLiter.text != "") && (textFieldKronor.text != "") {
            
            // Reference to our app delegate
            
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            // Reference moc
            
            let contxt: NSManagedObjectContext = appDel.managedObjectContext!
            let en = NSEntityDescription.entityForName("Tankningslista",inManagedObjectContext: contxt)
            
            
            if (existingTankning != nil) {
                
                
                //Sorteringsdatum
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM"
                
                var liter = (textFieldLiter.text! as NSString).doubleValue
                var kronor = (textFieldKronor.text! as NSString).doubleValue
                var literpris = roundFrac2((kronor / liter))
                let sorteringsdatum = dateFormatter.stringFromDate(datePickerDatum.date)
                
                existingTankning.setValue(liter, forKey: "liter")
                existingTankning.setValue(kronor, forKey: "kronor")
                existingTankning.setValue(literpris, forKey: "literpris")
                existingTankning.setValue(datePickerDatum.date, forKey: "datum")
                existingTankning.setValue(sorteringsdatum, forKey: "sorteringsDatum")
                
            }
            else {
                // Use your NSManagedModel to initialize not only the Model Keyword!
                var nyTankning = Model(entity: en!, insertIntoManagedObjectContext: contxt)
                
                //Sorteringsdatum
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM"
                
                // Map our properties
                
                var liter = textFieldLiter.text!.toDouble
                var kronor = textFieldKronor.text!.toDouble
                var literpris = roundFrac2((kronor / liter))
                let sorteringsdatum = dateFormatter.stringFromDate(datePickerDatum.date)
                
                nyTankning.setValue(liter, forKey: "liter")
                nyTankning.setValue(kronor, forKey: "kronor")
                nyTankning.setValue(literpris, forKey: "literpris")
                nyTankning.datum = datePickerDatum.date
                nyTankning.sorteringsDatum = sorteringsdatum
                
                
            }
            
            // Save our context
            
            
            contxt.save(nil)
            
            if contxt.save(nil) {
                
                // Fetch the Data from Core Data first....
                
                let fetchRequest = NSFetchRequest(entityName: "Tankningslista")
                var error:NSError?
                
                var result = contxt.executeFetchRequest(fetchRequest, error: &error) as! [Model]
                
                for res in result {
                    // Now you can display the data
                    println(res.liter)
                    println(res.kronor)
                    println(res.literpris)
                    println(res.datum)
                    println(res.sorteringsDatum)
                }
                
                // End of the fetching
                
            } else {
                
                println(NSError)
                
            }
            
            
            // navigate back to root vc
            self.navigationController?.popToRootViewControllerAnimated(true)
            

        }
        else {
            alertViewEmptyFields()
        }
        
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.bannerView?.hidden = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.bannerView?.hidden = true
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
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
