//
//  ProvinceCityDistrictPickerView.swift
//  SwiftDemos
//
//  Created by twt on 16/4/4.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit

struct Province {
    var name:String?
    var citys:[City]
    init(){
        self.citys = [City]()
    }
}
struct City {
    var name:String?
    var districts:[District]
    init(){
        self.districts = [District]()
    }
}
struct District {
    var name:String?
    var zipcode:String?
}



class ProvinceCityDistrictPickerView: UIPickerView ,UIPickerViewDataSource,UIPickerViewDelegate{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var data:[Province]?
    var selectProvince = 0
    var selectCity = 0
    var selectDistrict = 0
//    UIPickerViewDataSource
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//        if data == nil{
//            return 0
//        }
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component{
        case 0:
            return data!.count
        case 1:
            return data![selectProvince].citys.count
        case 2:
            return data![selectProvince].citys[selectCity].districts.count
        default:
            return 0
        }
//        return data![component].citys.count
    }
    //UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0:
            return data![row].name
        case 1:
            return data![selectProvince].citys[row].name
        case 2:
            return data![selectProvince].citys[selectCity].districts[row].name
        default:
            return nil
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
        case 0:
            self.selectProvince = row
//            selectedRowInComponent(<#T##component: Int##Int#>)
            self.selectCity = 0
            self.selectDistrict = 0
        case 1:
            self.selectCity = row
            self.selectDistrict = 0
        case 2:
            self.selectDistrict = row
        default:
           break
        }
        self.reloadData()

    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func reloadData() {
        reloadAllComponents()
    }
}
