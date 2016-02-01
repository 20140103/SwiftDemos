//
//  ServicesTableViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/13.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit

import CoreBluetooth

//Peripheral 外围设备
//service 服务
//characteristic 特性


//struct PeripheralInfo {
//    var service:CBService
//    var characteristics:[CBCharacteristic]
//}

class ServicesTableViewController: UITableViewController ,TableViewHeaderViewDelegate,CBPeripheralDelegate{

    let headerID = "header"
    
    @IBOutlet var blueNameLabel: UILabel!
    
    @IBOutlet var bleuUUIDLabel: UILabel!
    
    @IBOutlet var blueStatus: UILabel!
    
    var bleInfo:BLEInfo!
    
    var isShow:Bool!
    let testData = [
        [1,2,3,4]
        ,[1,2,3,4,5]
        ,[1,2,3,4,5]
    ]
//    var peripheralsInfos:Dictionary<CBUUID,[PeripheralInfo]>!{
//        didSet{
//            headerInSection = Array(peripheralsInfos.keys)
////            peripheralInfoArray = Array(peripheralsInfos.values)
//        }
//    }

    var peripheralsInfos:Dictionary<String,PeripheralInfo>!{
        didSet{
            headerInSection = Array(peripheralsInfos.keys)
            //            peripheralInfoArray = Array(peripheralsInfos.values)
        }
    }
    var headerInSection:[String]!
    var peripheralInfoArray:PeripheralInfo!
    /*
    即时警报	org.bluetooth.service.immediate_alert	0x1802	已采纳
    链路丢失	org.bluetooth.service.link_loss	0x1803	已采纳
    射频功率	org.bluetooth.service.tx_power	0x1804	已采纳
    Alert Level	org.bluetooth.characteristic.alert_level	0x2A06	Adopted
    Tx Power Level	org.bluetooth.characteristic.tx_power_level	0x2A07	Adopted
    */
    // 1802
    // 1803
    // 1804
//    let servicesMap = [0x1802:"immediate alert",0x1803:"link loss",0x1804:"tx power"]
    let servicesMap = ["1802":"即时警报","1803":"链路丢失","1804":"射频功率","1805":"当前时间","180F":"Battery"]
    let characteristicsMap = ["2A06":"Alert Level","2A07":"Tx Power Level"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //这两句是必须要 如果HeaderFooterView使用Xib的方式自定义 要在代码中使用必须先注册
//        let sectionHeaderNib: UINib = UINib(nibName: "NibTableViewHeaderView", bundle: NSBundle.mainBundle())
//        self.tableView.registerNib(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: "headerView")
        isShow = false
        peripheralsInfos = Dictionary<String,PeripheralInfo>()
        NSLog("\(bleInfo)")
        self.bleuUUIDLabel.lineBreakMode  = NSLineBreakMode.ByWordWrapping
        self.bleuUUIDLabel.numberOfLines = 0
    }

    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        let textColor = UIColor.redColor()
        let attributes = [
            NSForegroundColorAttributeName : textColor
//            NSFontAttributeName : font,
//            NSTextEffectAttributeName : NSTextEffectLetterpressStyle
        ]
        let attributedString = NSAttributedString(string: "Disconnected. Data is Stale.", attributes: attributes)
        
        self.blueNameLabel.text = bleInfo.peripheral.name
        self.bleuUUIDLabel.text = "UUID:\(bleInfo.peripheral.identifier.UUIDString)"
        if(bleInfo.peripheral.state == CBPeripheralState.Connected){
            self.blueStatus.text = "Connected"
        }else{
            self.blueStatus.attributedText = attributedString
        }
        self.bleInfo.peripheral.delegate = self
        self.bleInfo.peripheral.discoverServices(nil)
        NSLog(self.bleInfo.advertisementData.debugDescription)
        peripheralsInfos["advertisement"] = nil
//        self.bleInfo.peripheral.description
//        self.bleInfo.peripheral.valueForKey(CBAdvertisementDataLocalNameKey)
//        self.blueStatus.text = bleInfo.peripheral.state == CBPeripheralState.Connected ?  "Connected" : "Disconnected. Data is Stale."
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showAction(sender:UIButton){
        self.isShow = !self.isShow
        //重新加载指定分组数据并使用动画
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    // MARK: - TableViewHeaderViewDelegate
    func headerViewButtonDidClick(tableViewHeaderView: NibTableViewHeaderView, isShow: Bool) {
        NSLog("isShow = \(isShow)")
        self.isShow = !self.isShow
        self.tableView.reloadData()
    }
    // MARK: - CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        NSLog("didDiscoverServices")
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, forService: service )
        }

    }
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if (error != nil){
            NSLog("发现错误的特征：\(error!.localizedDescription)")
            return
        }
    
        NSLog("服务UUID:\(service.UUID.UUIDString)")
        for  characteristic in service.characteristics!  {
            //罗列出所有特性，看哪些是notify方式的，哪些是read方式的，哪些是可写入的。
            let serverDescription = servicesMap[service.UUID.UUIDString]
            let characteristicDescription = characteristicsMap[characteristic.UUID.UUIDString]
            NSLog("\(service.UUID.description) 服务UUID:\(serverDescription == nil ? service.UUID.UUIDString : serverDescription!)         特征UUID:\( characteristicDescription == nil ? characteristic.UUID.UUIDString : characteristicDescription!) ")
            
            switch(characteristic.UUID.description){
                case "Battery Level":
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic )
                case "2A2B":
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic )
                default:
                break
            }
//            peripheralsInfos[service.UUID]?.append(PeripheralInfo(service: service, Characteristic: characteristic))
        }
        peripheralsInfos[service.UUID.UUIDString] = PeripheralInfo(service: service, characteristics: service.characteristics!)
        self.tableView.reloadData()
//        self.tableView.reloadSections(NSIndexSet(index: peripheralsInfos.count == 0 ? 0 : peripheralsInfos.count - 1 ), withRowAnimation: UITableViewRowAnimation.Fade)

    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        NSLog("didUpdateNotificationStateForCharacteristic: " + characteristic.debugDescription)
        self.tableView.reloadData()
    }
   
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        NSLog("Sections \(self.peripheralsInfos.keys.count)")
        return self.peripheralsInfos.keys.count//testData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            if(isShow!){
                return 3//testData[section].count
            }else{
                return 0
            }
            
        }else{
            let sectionUUID = headerInSection[section]
            let count = peripheralsInfos[sectionUUID]?.characteristics.count
            NSLog("self.peripheralsInfos.values.count = \(count)")
            return count!//self.peripheralsInfos.values.count//testData[section].count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if(indexPath.section == 0){
             cell = tableView.dequeueReusableCellWithIdentifier("AdvertisementCell", forIndexPath: indexPath)
        }else{
             cell = tableView.dequeueReusableCellWithIdentifier("ServiceCell", forIndexPath: indexPath)
        }
        //AdvertisementCell
        // Configure the cell...
//        cell.textLabel?.text = "Battery Level"
//        cell.detailTextLabel?.text = "64%"
        
        if(indexPath.section == 0){
            switch(indexPath.row){
                case 0:
//                    let advertisementData = self.bleInfo.advertisementData
//                    let isConnectable = advertisementData[CBAdvertisementDataIsConnectable] as! Int
                    cell.textLabel?.text = "Yes"
                    cell.detailTextLabel?.text = "Device Is Connectable"
                case 1:
                    let advertisementData = self.bleInfo.advertisementData
                    let localNameKey = advertisementData[CBAdvertisementDataLocalNameKey]
                    cell.textLabel?.text = (localNameKey as! String)
                    cell.detailTextLabel?.text = "Local Name"
                case 2:
                    let advertisementData = self.bleInfo.advertisementData
                    let serviceUUIDsKey = advertisementData[CBAdvertisementDataServiceUUIDsKey] as! [CBUUID]
                    
                    cell.textLabel?.text = serviceUUIDsKey.debugDescription
                    cell.detailTextLabel?.text = "Service UUIDs"
            default:
                break
            }
        }else{
            //characteristic.properties
            let sectionUUID = headerInSection[indexPath.section]
            let info = peripheralsInfos[sectionUUID]?.characteristics[indexPath.row]
            
            //        let serverDescription = servicesMap[sectionUUID]
            let characteristicDescription = characteristicsMap[info!.UUID.UUIDString]
            //NSLog("服务UUID:\(serverDescription == nil ? service.UUID.UUIDString : serverDescription!)         特征UUID:\( characteristicDescription == nil ? characteristic.UUID.UUIDString : characteristicDescription!) ")
            cell.textLabel?.text = characteristicDescription == nil ? info!.UUID.description : characteristicDescription! //info!.UUID.description
            
            NSLog("info?.value : \(info?.value)")
            let value = info?.value
            
            if(value != nil && value!.length > 0){
                var batteryLevel: Int = 0
                value!.getBytes(&batteryLevel, range:NSRange(location: 0, length: 1))
                cell.detailTextLabel?.text = "\(batteryLevel)%"
            }else{
                cell.detailTextLabel?.text = "\(info!.properties.rawValue)"
            }
        }
        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        tableView.tableHeaderView?.backgroundColor = UIColor.redColor()
        if(section == 0){
            return "ADVERTISEMENT DATA"
        }
        let sectionUUID = headerInSection[section]
        
        let serverDescription = servicesMap[sectionUUID]
        return serverDescription == nil ? sectionUUID : serverDescription!//"\(headerInSection[section])"//"Battery Level"
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(headerID)
        if(sectionHeaderView == nil){
            sectionHeaderView = UITableViewHeaderFooterView(reuseIdentifier: headerID)
        }
        sectionHeaderView?.contentView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        if(section == 0){
            
            let showBtn = UIButton(type: UIButtonType.System)
            
            showBtn.setTitle(self.isShow! ? "Hide" : "Show", forState: UIControlState.Normal)

            showBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            showBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            //这个必须设置
            showBtn.translatesAutoresizingMaskIntoConstraints = false
            showBtn.addTarget(self, action: "showAction:", forControlEvents: UIControlEvents.TouchUpInside)
            sectionHeaderView?.contentView.addSubview(showBtn)

            let right = NSLayoutConstraint(item: showBtn, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: showBtn.superview, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: showBtn, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: sectionHeaderView?.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            sectionHeaderView?.addConstraint(right)
            sectionHeaderView?.addConstraint(centerY)
        }
        return sectionHeaderView

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showCharacteristic"  {
            let selectCell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(selectCell)
            if(indexPath != nil){
                let sectionUUID = headerInSection[indexPath!.section]
                let info = peripheralsInfos[sectionUUID]?.characteristics[indexPath!.row]
                NSLog("index \(indexPath.debugDescription)")
                let destinationController = segue.destinationViewController as! CharacteristicTableViewController
                destinationController.navigationItem.title = selectCell.textLabel?.text//info?.description//"Characteristic"
                destinationController.characteristic = info
            }
            
            
//            destinationController.bleInfo = self.blesArray[selectCell.tag]//self.bles.values.reverse()[selectRow]
        }
    }


}
