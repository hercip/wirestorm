//
//  MasterViewController.swift
//  wirestorm
//
//  Created by Ciprian Herman on 24/01/16.
//  Copyright © 2016 Ciprian Herman. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func getGrayImage() -> Void {
        let color = UIColor.grayColor()
        let size = CGSizeMake(50,50)
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = image
    }
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var rows = Array<TableData>()
    let dataProvider = DataProvider()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataProvider.requestData { (rows) -> Void in
            self.rows = rows
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = rows[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.stringUrl = row.lrgpic
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let row = rows[indexPath.row]
        cell.textLabel!.text = row.name
        cell.detailTextLabel?.text = row.position
        cell.imageView!.getGrayImage()
        cell.imageView!.downloadedFrom(link: row.smallpic, contentMode: .ScaleAspectFit) { (color) -> Void in
            cell.backgroundColor = color
        }
        
        return cell
    }

}

