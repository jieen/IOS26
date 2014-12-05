//
//  ItemsVC.swift
//  CodeCamp.MoneyKeeper
//
//  Created by Khiem Ngo Viet on 12/5/14.
//  Copyright (c) 2014 Khiem Ngo Viet. All rights reserved.
//

import UIKit
import CoreData

class ItemsListVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController!
    let rowHeight:CGFloat = 51
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let managedContext = DataManager.singleton.managedObjectContext!
        //
        ////        let results = Category.all()
        ////        for cate in results as [Category]{
        ////            println(cate.name)
        ////        }
        //        let items = Item.all()
        //        for cate in items as [Item]{
        //            println(cate.descriptions)
        //        }
        
        self.tableView.rowHeight = rowHeight
        self.tableView.registerNib(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "Cell")
        let sortdatedesc = NSSortDescriptor(key: "date", ascending: false)
        fetchResultController = Item.createFetchResultsController([sortdatedesc],sectionKey: nil, queryString: nil)
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
    
    
    @IBAction func onEdit(sender:UIBarButtonItem) {
        tableView.setEditing(!tableView.editing, animated: true)
    }
    
    @IBAction func onAdd(sender: UIBarButtonItem) {
        //        let date = NSDate()
        //                let categories = Category.all() as [Category]
        //                let accounts = Account.all() as [Account]
        //       Item.add(2111, description: "", date: date, category: categories[5], account: accounts[1])
//        let itemDetail = self.storyboard?.instantiateViewControllerWithIdentifier("ItemDetail") as ItemDetailVC
//        self.navigationController?.pushViewController(itemDetail, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InsertItem"{
            let itemDetail = segue.destinationViewController as ItemDetailVC
            itemDetail.editMode = EditMode.AddNew
        }
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchResultController.sections![section] as NSFetchedResultsSectionInfo
        let idf = sectionInfo.numberOfObjects
        let count = fetchResultController.fetchedObjects?.count
        return count!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as ItemCell
        let item = fetchResultController.objectAtIndexPath(indexPath) as Item
        if item.category.isIncome.boolValue{
            cell.item.textColor = UIColor.blueColor()
        }
        else{
            cell.item.textColor = UIColor.blackColor()

        }
        cell.item.text = item.category.isIncome.boolValue ? "Thu: \(item.category.name)" : "Chi: \(item.category.name)"
        cell.amount.text = "\(item.amount)"
        //cell.date.text = item.date
        return cell
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = fetchResultController.objectAtIndexPath(indexPath) as Item
            DataManager.singleton.managedObjectContext?.deleteObject(item)
            DataManager.singleton.saveContext()
        } else if editingStyle == .Insert {
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !tableView.editing{
            let item = fetchResultController.objectAtIndexPath(indexPath) as Item
            let detailVC = storyboard?.instantiateViewControllerWithIdentifier("ItemDetail") as ItemDetailVC
            detailVC.item = item
            detailVC.editMode = EditMode.Edit
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
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
            tableView.cellForRowAtIndexPath(indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            return
        }
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}

enum EditMode: Int{
    case AddNew, Edit
}

enum CategoryType: Int{
    case Expense, Income
}