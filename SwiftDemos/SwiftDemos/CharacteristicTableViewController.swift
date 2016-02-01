//
//  CharacteristicTableViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/20.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit
import CoreBluetooth

/*
READ/NOTIFIED VALUES
DESCRIPTORS
PROPERTIES


*/



class CharacteristicTableViewController: UITableViewController,ActionTableViewCellDelegate {
    let headerID = "headerID"
    
    @IBOutlet var characteristicDescriptionLabel: UILabel!
    @IBOutlet var uuidLabel: UILabel!
    
    @IBOutlet var blueNameLabel: UILabel!
    
    @IBOutlet var blueStatus: UILabel!
    
    var characteristic:CBCharacteristic!
    
    var titleForHeaderInSection:[String]!// = ["READ/NOTIFIED/INDICATED VALUES","WRITTEN VALUES","DESCRIPTORS","PROPERTIES"]
    var propertiesArray:[String]!
    var isWriteable = false
    var isNotifable = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.backgroundColor =  UIColor.groupTableViewBackgroundColor()
    }

    override func viewWillAppear(animated: Bool) {
        self.blueNameLabel.text = self.characteristic.service.peripheral.name
        self.uuidLabel.text = self.characteristic.UUID.UUIDString
        
//        let characteristicDescription = characteristicsMap[info!.UUID.UUIDString]
//        //NSLog("服务UUID:\(serverDescription == nil ? service.UUID.UUIDString : serverDescription!)         特征UUID:\( characteristicDescription == nil ? characteristic.UUID.UUIDString : characteristicDescription!) ")
//        cell.textLabel?.text = characteristicDescription == nil ? info!.UUID.description : characteristicDescription! //info!.UUID.description
        propertiesArray = [String]()
        
        self.characteristicDescriptionLabel.text = self.characteristic.UUID.description
        
    
        
        let propertiesValue = self.characteristic.properties.rawValue
        NSLog("propertiesValue \(propertiesValue)")
        if(propertiesValue == 0){
            titleForHeaderInSection = ["DESCRIPTORS","PROPERTIES"]
        }else{
            if propertiesValue & CBCharacteristicProperties.Read.rawValue != 0 {
                NSLog("Read")
                propertiesArray.append("Read")
            }
            if propertiesValue & CBCharacteristicProperties.Write.rawValue != 0 {
                NSLog("Write")
                isWriteable = true
                propertiesArray.append("Write")
            }
            if propertiesValue & CBCharacteristicProperties.Notify.rawValue != 0 {
                NSLog("Notify")
                isNotifable = true
                propertiesArray.append("Notify")
            }
            if propertiesValue & CBCharacteristicProperties.Indicate.rawValue != 0 {
                NSLog("Indicate")
                propertiesArray.append("Indicate")
            }
            if(isWriteable){
                titleForHeaderInSection = ["\(propertiesArray.debugDescription) VALUES","WRITTEN VALUES","DESCRIPTORS","PROPERTIES"]
            }else{
                titleForHeaderInSection = ["\(propertiesArray.debugDescription) VALUES","DESCRIPTORS","PROPERTIES"]
            }
        }
        
        
//        self.characteristic.descriptors?.count
        NSLog("descriptors\(self.characteristic.descriptors.debugDescription)")
        let textColor = UIColor.redColor()
        let attributes = [
            NSForegroundColorAttributeName : textColor
        ]
        let attributedString = NSAttributedString(string: "Disconnected. Data is Stale.", attributes: attributes)
        
        if(self.characteristic.service.peripheral.state == CBPeripheralState.Connected){
            self.blueStatus.text = "Connected"
        }else{
            self.blueStatus.attributedText = attributedString
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return titleForHeaderInSection.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch titleForHeaderInSection[section]
        {
        case "\(propertiesArray.debugDescription) VALUES":
            return 2
        case "PROPERTIES":
            return propertiesArray.count
        case "WRITTEN VALUES":
            return 1
        case "DESCRIPTORS":
            return 0
        default:
            break
        }
        return 0
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int)->String?{
        return titleForHeaderInSection[section]
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sectionHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(headerID)
        if(sectionHeaderView == nil){
            sectionHeaderView = UITableViewHeaderFooterView(reuseIdentifier: headerID)
        }
        sectionHeaderView?.contentView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return sectionHeaderView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        
        switch titleForHeaderInSection[indexPath.section]
        {
        case "\(propertiesArray.debugDescription) VALUES":
            if(indexPath.row == 0){
                cell = tableView.dequeueReusableCellWithIdentifier("actionCell", forIndexPath: indexPath)
                cell.tag = 100
                (cell as! ActionTableViewCell).rightBtn.hidden = !isNotifable
                (cell as! ActionTableViewCell).delegate = self
            }else{
                 cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
                cell.textLabel?.text = "NO Value"
                
            }
            
            
        case "WRITTEN VALUES":
            if(indexPath.row == 0){
                cell = tableView.dequeueReusableCellWithIdentifier("actionCell", forIndexPath: indexPath) as! ActionTableViewCell
                cell.tag = 101
                (cell as! ActionTableViewCell).leftBtn.setTitle("Write new value", forState: UIControlState.Normal)
                (cell as! ActionTableViewCell).delegate = self
            }else{
                cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
            }
        case "DESCRIPTORS":
            cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
            
            break
        case "PROPERTIES":
            cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
            cell.textLabel?.text = self.propertiesArray[indexPath.row]
            
        default:
            
            break
        }

        // Configure the cell...

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath == NSIndexPath(forRow: 0, inSection: 0) || indexPath == NSIndexPath(forRow: 0, inSection: 1)){
            return 34
        }
        return 44
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: -ActionTableViewCellDelegate
    func rightButtonOnClick(tableViewCell: ActionTableViewCell) {
        NSLog("rightButtonOnClick %i ", tableViewCell.tag)
        tableViewCell.rightBtn.selected = !tableViewCell.rightBtn.selected
        switch tableViewCell.tag {
        case 100:
            NSLog("start notif")
        case 101:
            NSLog("write new value")
        default:
            break
        }
    }
    func leftButtonOnClick(tableViewCell: ActionTableViewCell) {
        switch tableViewCell.tag {
        case 100:
            NSLog("read value")
        case 101:
            NSLog("write new value")
        default:
            break
        }
        NSLog("leftButtonOnClick %i ", tableViewCell.tag)
    }

}
