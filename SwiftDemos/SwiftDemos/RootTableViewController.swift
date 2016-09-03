//
//  RootTableViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 15/12/4.
//  Copyright © 2015年 twt. All rights reserved.
//

import UIKit

struct Theme {
    var themeName:String!
    var demos:[Demo]!
}
struct Demo{
    var demoTitle:String!
    var description:String!
    var viewControllerID:String!//在stroyboard中设置的标识名称与类名一至
}


class RootTableViewController: UITableViewController {

    let themes:[Theme] = [
        Theme(themeName: "UITableViewController",
            demos: [Demo(demoTitle: "SelfSizeCellDemoTableViewController",description:"SelfSizeCellDemoTableViewController", viewControllerID: "SelfSizeCellDemoTableViewController")
                   ,Demo(demoTitle: "TableViewController",description:"TableViewController", viewControllerID: "TableViewController")
                    ,Demo(demoTitle: "ARCViewController",description:"ARCViewController", viewControllerID: "ARCViewController")
                ,Demo(demoTitle: "AlertViewController",description:"AlertViewController", viewControllerID: "AlertViewController")
                //MotionManagerViewController
                ,Demo(demoTitle: "MotionManagerViewController",description:"MotionManagerViewController", viewControllerID: "UITabBarController")
                //LocationManagerViewController
                ,Demo(demoTitle: "LocationManagerViewController",description:"LocationManagerViewController", viewControllerID: "LocationManagerViewController")
                //BluetoolsTableViewController
                ,Demo(demoTitle: "BluetoolsTableViewController",description:"BluetoolsTableViewController", viewControllerID: "BluetoolsTableViewController")
                //DataParserViewController
                ,Demo(demoTitle: "DataParserViewController",description:"DataParserViewController", viewControllerID: "DataParserViewController")
            ]
            
        )
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.tableView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return themes.count
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return themes[section].demos.count
//    }
//
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
//
//        // Configure the cell...
//        cell.textLabel?.text = themes[indexPath.section].demos[indexPath.row].demoTitle
//        cell.detailTextLabel?.text = themes[indexPath.section].demos[indexPath.row].viewControllerID
//        return cell
//    }
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return themes[section].themeName
//    }
//    
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(themes[indexPath.section].demos[indexPath.row].viewControllerID)
//        vc.title = themes[indexPath.section].demos[indexPath.row].demoTitle
//        
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
