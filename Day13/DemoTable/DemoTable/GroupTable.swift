//
//  GroupTable.swift
//  DemoTable
//
//  Created by cuong minh on 11/4/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

import UIKit

class GroupTable: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var data = Array<DataItem>()
        
    var tableView: UITableView?
    
    override func loadView() {
        super.loadView()
        
        data.append(DataItem(title: "Fruits", data: ["Orange", "Lemon", "Banana", "Black Berry"],image: "fruits.png"))
        data.append(DataItem(title: "Things", data:["Clock", "Watch", "Tivi"], image: "girl.png"))
        data.append(DataItem(title: "Girls", data:["Miranda Kerr", "Kate Upton", "Adriana Lima", "Rosie Huntington-Whiteley"],image: "things.png"))
        
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView!)
        tableView!.delegate = self
        tableView!.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let dataItem = data[section] as DataItem
        return dataItem.data.count
    }
    
    
    ////
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellID = "id"
        var cell: UITableViewCell
        if let dequeCell: AnyObject = tableView.dequeueReusableCellWithIdentifier(cellID) {
            cell = dequeCell as UITableViewCell
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        let dataItem = data[indexPath.section] as DataItem
        cell.textLabel.text = dataItem.data[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dataItem = data[section] as DataItem
        return dataItem.title
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = data[section] as DataItem
        
        let imageV = UIImageView(image: item.image)
        imageV.contentMode = UIViewContentMode.Left
        imageV.frame = CGRect(x: 0, y: 0, width: tableView.rowHeight, height: tableView.rowHeight)
        
        return imageV
    }

}
