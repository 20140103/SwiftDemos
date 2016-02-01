//
//  BluetoolsTableViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/12.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation

//struct BLEInfo {
//    var peripheral:CBPeripheral
//    var RSSI:NSNumber
//    var advertisementData: [String : AnyObject]
//}
class BluetoolsTableViewController: UITableViewController,CBCentralManagerDelegate ,CBPeripheralDelegate{

    var centralManager:CBCentralManager!
    //所有扫描到的蓝牙设备的字典形式保存
    var bles:Dictionary<String,BLEInfo>!{
        didSet{
            blesArray = Array(self.bles.values)
        }
    }
    //所有扫描到的蓝牙设备的数组形式
    var blesArray:[BLEInfo]!
    
//    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem().
        initBlueCentralManager()
        //初始化字典
        bles = Dictionary<String,BLEInfo>()
        
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.attributedTitle = NSAttributedString(string: "扫描蓝牙设备")
//        self.refreshControl?.addTarget(self, action: "scanBle:", forControlEvents: UIControlEvents.ValueChanged)
//        self.refreshControl?.backgroundColor = UIColor.redColor()
//        self.refreshControl?.autoresizesSubviews = false
        
    }
    override func viewDidDisappear(animated: Bool) {
        centralManager.stopScan()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scanBle(senden:AnyObject){
        NSLog("scanBle")
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
//        self.refreshControl?.endRefreshing()
    }
    func initBlueCentralManager(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    @IBAction func readRSSI(sender: UIButton) {
//        self.blues.map() { $0.peripheral.readRSSI()  }
//        self.bles.values.reverse().map(){
//            $0.peripheral.readRSSI()
//        }
         centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(central: CBCentralManager) {
        NSLog(central.debugDescription)
        switch(central.state){
        case CBCentralManagerState.PoweredOn:
            NSLog("powered On")
            central.scanForPeripheralsWithServices(nil, options: nil)
        case CBCentralManagerState.PoweredOff:
            NSLog("powered Off")
        default:
            NSLog("centralManagerDidUpdateState \(central.state)")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        self.bles[peripheral.identifier.UUIDString] = BLEInfo(peripheral: peripheral, RSSI: RSSI,advertisementData:advertisementData)
//        NSLog("RSSI:\(RSSI) UUID \(peripheral.identifier.UUIDString)")
        peripheral.delegate = self
        advertisementData[CBAdvertisementDataLocalNameKey]
        NSLog(advertisementData.debugDescription)
        NSLog("\(advertisementData[CBAdvertisementDataLocalNameKey])")
        central.connectPeripheral(peripheral, options: nil)
        self.tableView.reloadData()
    }
    //连接成功
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        NSLog("didConnectPeripheral")
        peripheral.delegate = self
        
        peripheral.discoverServices(nil)
        peripheral.readRSSI()//读取RSSI
    }
    //断开连接
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        NSLog("didDisconnectPeripheral \(peripheral.name) error:\(error.debugDescription)")
        central.connectPeripheral(peripheral, options: nil)
    }
    //连接失败
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        NSLog("didFailToConnectPeripheral")
    }
    // MARK: - CBPeripheralDelegate
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        NSLog("didDiscoverServices")
        self.tableView.reloadData()
    }
   
    func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
//        NSLog("\(peripheral.name) didReadRSSI \(RSSI) error \(error)")
        self.bles[peripheral.identifier.UUIDString]?.RSSI = RSSI//更新RSSI的值
        self.tableView.reloadData()
        peripheral.readRSSI()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.bles.values.count//self.blues.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! BluetoolsTableViewCell
        // Configure the cell...
        let ble = blesArray[indexPath.row]//blues[indexPath.row]
        cell.blueName.text = ble.peripheral.name
        let sCount = ble.peripheral.services?.count
        cell.servicesLabel.text = "\(sCount == nil ? "No" : "\(sCount! - 2)") services"//ble.peripheral.identifier.UUIDString//
        cell.signalView.titleLabel?.text = "\(ble.RSSI.integerValue >= 0 ? "---" : ble.RSSI)"
        cell.tag = indexPath.row
        return cell
    }
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        selectRow = indexPath.row
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
        
        if segue.identifier == "showServices"  {
            let selectCell = sender as! BluetoolsTableViewCell
            let destinationController = segue.destinationViewController as! ServicesTableViewController
            destinationController.navigationItem.title = "Peripheral"
            destinationController.bleInfo = self.blesArray[selectCell.tag]//self.bles.values.reverse()[selectRow]
        }
    }
    

}
