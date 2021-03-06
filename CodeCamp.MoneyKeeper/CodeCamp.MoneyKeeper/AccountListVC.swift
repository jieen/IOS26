//
//  AccountListVC.swift
//  CodeCamp.MoneyKeeper
//
//  Created by Khiem Ngo Viet on 12/6/14.
//  Copyright (c) 2014 Khiem Ngo Viet. All rights reserved.
//

import UIKit
import CoreData
class AccountListVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tài khoản"
        self.tableView.rowHeight = 60.0
        let sortNameAZ = NSSortDescriptor(key: "name", ascending: true)
        fetchResultController = Account.createFetchResultsController([sortNameAZ], sectionKey: nil, queryString: nil)
        fetchResultController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        var error: NSError?
        NSFetchedResultsController.deleteCacheWithName("root")
        fetchResultController.performFetch(&error)
        if error != nil {
            println("\(error?.description)  - \(error?.debugDescription)")
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchResultController.fetchedObjects?.count
        return count!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("AccountCell") as AccountCell
        let account = fetchResultController.objectAtIndexPath(indexPath) as Account
        cell.accountNameLable.text = account.name
        cell.remainAmountLabel.text = NSNumberFormatter.stringFromCurrency(account.currentAmount)
        cell.originAmountLabel.text = NSNumberFormatter.stringFromCurrency(account.originAmount)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let accountDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("AccountDetail") as AccountDetailVC
        accountDetailVC.account = fetchResultController.objectAtIndexPath(indexPath) as Account
        self.navigationController?.pushViewController(accountDetailVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Delete:
            
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as AccountCell
            let account = fetchResultController.objectAtIndexPath(indexPath!) as Account
            cell.accountNameLable.text = account.name
            cell.remainAmountLabel.text = NSNumberFormatter.stringFromCurrency(account.currentAmount)
            cell.originAmountLabel.text = NSNumberFormatter.stringFromCurrency(account.originAmount)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    
    
 
    
}
