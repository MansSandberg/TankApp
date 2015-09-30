//
//  tankningarTableViewController.swift
//  TankApp
//
//  Created by Måns Sandberg on 2015-01-11.
//  Copyright (c) 2015 Måns Sandberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class tankningarTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    let managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var fetchedResultsController: NSFetchedResultsController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: allaTankningarFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: "sorteringsDatum", cacheName: nil)
        fetchedResultsController?.delegate = self
        fetchedResultsController?.performFetch(nil)


    }
    
    func alertViewFirstTime() {
        let alertController = UIAlertController(title: "TankApp", message:
            "Du kan lägga till en ny tankning genom att trycka på plusknappen (+).", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func allaTankningarFetchRequest() -> NSFetchRequest {
        
        var fetchRequest = NSFetchRequest(entityName: "Tankningslista")
        let sortDescriptor = NSSortDescriptor(key: "datum", ascending: false)
        let sectionSortDescriptor = NSSortDescriptor(key: "sorteringsDatum", ascending: false)

        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [sortDescriptor, sectionSortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        return fetchRequest
    }
    
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let firstTime: Bool? = userDefaults.objectForKey("firstTime") as? Bool
        
        if (firstTime == nil) {
            userDefaults.setBool(true, forKey: "firstTime")
            alertViewFirstTime()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController?.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.fetchedResultsController?.sections![section] as! NSFetchedResultsSectionInfo
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let sectionDatum = dateFormatter.dateFromString(sectionInfo.name!)
        dateFormatter.dateFormat = "MMMM yyyy"
        let sectionTitle = dateFormatter.stringFromDate(sectionDatum!).capitalizedString
        
        return sectionTitle
    }
    
    //MARK: NSFetchedResultsController Delegate Functions
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Move:
            break
        case NSFetchedResultsChangeType.Update:
            break
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        }
        
        switch editingStyle {
        case .Delete:
            managedObjectContext?.deleteObject(fetchedResultsController?.objectAtIndexPath(indexPath) as! Model)
            managedObjectContext?.save(nil)
        case .Insert:
            break
        case .None:
            break
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertRowsAtIndexPaths(NSArray(object: newIndexPath!) as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!) as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Move:
            tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!) as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths(NSArray(object: newIndexPath!) as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Update:
            tableView.cellForRowAtIndexPath(indexPath!)
            break
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        
        
        let CellID: NSString = "Cell"
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellID as String) as! UITableViewCell
        
        
        let fetchRequest = NSFetchRequest(entityName: "Tankningslista")
        
        if let cellContact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Model {
            
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let strDate = dateFormatter.stringFromDate(cellContact.datum)
            
            cell.textLabel?.text = "\(strDate)"
            cell.detailTextLabel?.text = "\(cellContact.liter) Liter, \(cellContact.kronor) Kronor, \(cellContact.literpris) Kronor/Liter"
            
        }

        return cell
    }
    
    
    @IBAction func doneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "update" {
            let destination = segue.destinationViewController as! nyTankningViewController
            if let indexPath = self.tableView?.indexPathForCell(sender as! UITableViewCell) {
                let object = fetchedResultsController?.objectAtIndexPath(indexPath) as? Model
                destination.liter! = "\(object!.liter)"
                destination.kronor! = "\(object!.kronor)"
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let strDate = dateFormatter.stringFromDate(object!.datum)
                destination.datum = "\(strDate)"
                destination.existingDatum = (object!.datum)
                destination.existingTankning = object
            }
        }
    }
}