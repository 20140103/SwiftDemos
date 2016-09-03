//
//  DataParserViewController.swift
//  SwiftDemos
//
//  Created by twt on 16/4/4.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit

class DataParserViewController: UIViewController ,NSXMLParserDelegate{

    @IBOutlet weak var pcdPickerData: ProvinceCityDistrictPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        xmlParser("province_data")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func xmlParser(xmlFileName:String){
//        var data1:NSData = NSData(bytes: string, length: count(string))
//        let xmlData = NSData(contentsOfFile: xmlFileName)
        let xmlParser = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(xmlFileName, ofType: "xml")!))
        //委托
        xmlParser!.delegate = self
        //开始解析
        xmlParser!.parse()
    }
    
    var elementName:String = ""
    var attributeDice:[NSObject : AnyObject] = [NSObject : AnyObject]()
    
    var data:[Province] = [Province]()
    var tempProvince:Province!
    var tempCity:City!
    /*
    开始解析的时候会执行该方法，通过此方法可以得到节点名称和属性
    */
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
//        print("didStartElement elementName = \(elementName) ")
        if elementName == "province"{
//            debugPrint("\(attributeDice["name"]!)")
            self.tempProvince = Province()
            self.tempProvince.name = attributeDict["name"]
//            self.data.append(self.tempProvince)
        }else if elementName == "city"{
//            debugPrint(       attributeDice["name"]!)
            self.tempCity = City()
            self.tempCity.name = attributeDict["name"]
//            self.tempProvince.citys.append(self.tempCity)
            
        }else if elementName == "district"{
            var district = District()
            district.name = attributeDict["name"]
            self.tempCity.districts.append(district)
//            debugPrint("        \(attributeDice["name"]!)")
        }
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("didEndElement elementName = \(elementName) ")
        switch elementName {
            case "province":
                self.data.append(self.tempProvince)
            case "city":
                self.tempProvince.citys.append(self.tempCity)
            case "root":
                debugPrint(self.data)
                pcdPickerData.data = self.data
                pcdPickerData.reloadData()
            default:
                break
        }
    }
    /*
    通过此方法得到节点包含的内容
    */
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        //        //因为XML里面可能包含了换行符合空格，可以通过此方法去掉换行符合空格
        let str:String! = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if str != ""{
            debugPrint("\(elementName):\(str)")
        }
//        debugPrint(string)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
