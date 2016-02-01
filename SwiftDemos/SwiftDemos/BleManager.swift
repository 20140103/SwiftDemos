//
//  BleManager.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/22.
//  Copyright © 2016年 twt. All rights reserved.
//

import Foundation
import CoreBluetooth

struct BLEInfo {
    var peripheral:CBPeripheral
    var RSSI:NSNumber
    var advertisementData: [String : AnyObject]
}

struct PeripheralInfo {
    var service:CBService
    var characteristics:[CBCharacteristic]
}
class BleManager :NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    
    private var centralManager:CBCentralManager!
    internal static let instance = BleManager() //这个位置使用 static，static修饰的变量会懒加载
    
    private override init(){
        print("create BleManager...");
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    func startScan(serviceUUIDs: [CBUUID]? = nil, options: [String : AnyObject]? = nil){
        NSLog("startScan")
        centralManager.scanForPeripheralsWithServices(serviceUUIDs, options: options)
    }
    func stopScan(){
        NSLog("stopScan")
        centralManager.stopScan()
    }
    //中央设备代理
    // MARK: - CBCentralManagerDelegate
    // 中央设备管理器状态更新
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
    //发现周边设备
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        advertisementData[CBAdvertisementDataLocalNameKey]
        NSLog(advertisementData.debugDescription)
        NSLog("\(advertisementData[CBAdvertisementDataLocalNameKey])")
        central.connectPeripheral(peripheral, options: nil)
    }
    //周边设备连接成功
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        NSLog("didConnectPeripheral")
        peripheral.discoverServices(nil)
        peripheral.readRSSI()//读取RSSI
    }
    //周边设备断开连接
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        NSLog("didDisconnectPeripheral \(peripheral.name) error:\(error.debugDescription)")
        central.connectPeripheral(peripheral, options: nil)
    }
    //周边设备连接失败
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        NSLog("didFailToConnectPeripheral")
    }
    
    //会恢复状态
    func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        NSLog("willRestoreState")
    }
    
    
    
    
    //
    //周边设备代理
    // MARK: - CBPeripheralDelegate
    //发现周边设备服务
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        NSLog("didDiscoverServices")
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, forService: service )
        }
    }
    //同边设备RSSI
    func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
        NSLog("didReadRSSI")
        peripheral.readRSSI()
    }
    //发现周边设备服务中的特征
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if (error != nil){
            NSLog("发现错误的特征：\(error!.localizedDescription)")
            return
        }
        
        NSLog("服务UUID:\(service.UUID.UUIDString)")
        for  characteristic in service.characteristics!  {
            
            if(characteristic.properties.rawValue & CBCharacteristicProperties.Notify.rawValue != 0 ){
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
            
            //罗列出所有特性，看哪些是notify方式的，哪些是read方式的，哪些是可写入的。
//            let serverDescription = servicesMap[service.UUID.UUIDString]
//            let characteristicDescription = characteristicsMap[characteristic.UUID.UUIDString]
//            NSLog("\(service.UUID.description) 服务UUID:\(serverDescription == nil ? service.UUID.UUIDString : serverDescription!)         特征UUID:\( characteristicDescription == nil ? characteristic.UUID.UUIDString : characteristicDescription!) ")
//
//            switch(characteristic.UUID.description){
//            case "Battery Level":
//                peripheral.setNotifyValue(true, forCharacteristic: characteristic )
//            case "2A2B":
//                peripheral.setNotifyValue(true, forCharacteristic: characteristic )
//            default:
//                break
//            }
//                        peripheralsInfos[service.UUID]?.append(PeripheralInfo(service: service, Characteristic: characteristic))
        }
//        peripheralsInfos[service.UUID.UUIDString] = PeripheralInfo(service: service, characteristics: service.characteristics!)
//        self.tableView.reloadData()
        //        self.tableView.reloadSections(NSIndexSet(index: peripheralsInfos.count == 0 ? 0 : peripheralsInfos.count - 1 ), withRowAnimation: UITableViewRowAnimation.Fade)
        
    }
    //当周边设备有通知消息来的时候回调此方法
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        NSLog("didUpdateNotificationStateForCharacteristic: " + characteristic.debugDescription)
//        self.tableView.reloadData()
    }
    //描述
    func peripheral(peripheral: CBPeripheral, didDiscoverDescriptorsForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        NSLog("didDiscoverDescriptorsForCharacteristic")
    }
    //
    func peripheral(peripheral: CBPeripheral, didDiscoverIncludedServicesForService service: CBService, error: NSError?) {
         NSLog("didDiscoverIncludedServicesForService")
    }
    //周边设备服务修改
    func peripheral(peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        NSLog("didModifyServices")
    }
    //周边设备特征值更新
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        NSLog("didUpdateValueForCharacteristic")
    }
    //周边设备描述更新
    func peripheral(peripheral: CBPeripheral, didUpdateValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        NSLog("didUpdateValueForDescriptor")
    }
    //向特征值写数据时回调的方法
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        NSLog("didWriteValueForCharacteristic")
    }
    //写描述信息时触发的方法
    func peripheral(peripheral: CBPeripheral, didWriteValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        NSLog("didWriteValueForDescriptor")
    }
    //周边设备更新名字
    func peripheralDidUpdateName(peripheral: CBPeripheral) {
        NSLog("peripheralDidUpdateName")
    }
    //周边设备RSSI更新时
    func peripheralDidUpdateRSSI(peripheral: CBPeripheral, error: NSError?) {
        NSLog("peripheralDidUpdateRSSI")
    }
    
    
}