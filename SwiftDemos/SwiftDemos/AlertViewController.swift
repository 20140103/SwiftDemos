//
//  AlertViewController.swift
//  SwiftDemos
//
//  Created by tdc-sw on 16/1/5.
//  Copyright © 2016年 twt. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController,UIPopoverPresentationControllerDelegate
        ,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    
    @IBOutlet var pickVIew: UIImageView!
    
    override func viewDidLoad() {
//        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "test", style: UIBarButtonItemStyle.Done, target: self, action: "showPopAlert:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "test", style: UIBarButtonItemStyle.Done, target: self, action: "showPopover:")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func showPopover(sender:AnyObject){
//        showAlertPopoverPressentation((sender as! UIBarButtonItem).)
    }
    
    
    @IBAction func showAlert(sender: UIButton) {
//        showAlertActionSheet()
        showAlertLogin()
        //showAlertPopoverPressentation(sender)
    }
    @IBAction func showActionSheel(sender: AnyObject) {
        showAlertActionSheet()
    }
    @IBAction func showPopAlert(sender: AnyObject) {
       showAlertPopoverPressentation(sender as! UIView)
    }
    
    @IBAction func showPopViewController(sender: AnyObject) {
        self.showPopoverViewController(sender as! UIView)
    }
    
    func showAlertLogin(){
        let alertController = UIAlertController(title: "对话框", message: "test", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "登录"
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("alertTextFieldDidChange:"), name: UITextFieldTextDidChangeNotification, object: textField)
        }
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "密码"
            textField.secureTextEntry = true
        }
        let cancelAction = UIAlertAction(title: "取消",style:UIAlertActionStyle.Cancel,handler:nil)
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default) {
            (action: UIAlertAction!) -> Void in
            let login = (alertController.textFields?.first)! as UITextField
            let password = (alertController.textFields?.last)! as UITextField
            print("\(login.text,password.text)")
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: nil)
        }
        okAction.enabled = false
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController,animated: true, completion: nil)
        
    }
    func alertTextFieldDidChange(notification: NSNotification){
        let alertController = self.presentedViewController as! UIAlertController?
        if (alertController != nil) {
            let login = (alertController!.textFields?.first)! as UITextField
            let okAction = alertController!.actions.last! as UIAlertAction
            let count = login.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            okAction.enabled = count > 2
        }
    }

    func showAlertActionSheet(){
        //        let alertController = UIAlertController(title: "对话框", message: "test", preferredStyle: UIAlertControllerStyle.Alert)
        let alertController = UIAlertController(title: "保存或删除数据", message: "删除数据将不可恢复", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "删除", style: UIAlertActionStyle.Destructive, handler: nil)
        let archiveAction = UIAlertAction(title: "保存", style: UIAlertActionStyle.Default, handler: nil)
        let  takePhotoAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) {
            (action: UIAlertAction!) -> Void in
                self.takePhoto()
            }
        let  localPhotoAction = UIAlertAction(title: "照片", style: UIAlertActionStyle.Default) {
            (action: UIAlertAction!) -> Void in
            self.localPhoto()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(localPhotoAction)
        
        self.presentViewController(alertController, animated: true,completion: nil)

    }
    //adaptivePresentationStyleForPresentationController
    func showAlertPopoverPressentation(sender:UIView){
//                let alertController = UIAlertController(title: "对话框", message: "test", preferredStyle: UIAlertControllerStyle.Alert)
        let alertController = UIAlertController(title: "保存或删除数据", message: "删除数据将不可恢复", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
//        let deleteAction = UIAlertAction(title: "删除", style: UIAlertActionStyle.Destructive, handler: nil)
        let archiveAction = UIAlertAction(title: "保存", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(cancelAction)
//        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        
        let popover = alertController.popoverPresentationController
        if (popover != nil){
            popover?.sourceView = sender
            popover?.sourceRect = sender.bounds
            popover?.permittedArrowDirections = UIPopoverArrowDirection.Any
        }
         self.presentViewController(alertController, animated: true,completion: nil)
    }
    
    func didEnterBackground(notification:NSNotification){
        self.presentedViewController!.dismissViewControllerAnimated(false, completion: nil)
    }
    func showPopoverViewController(sender:UIView){
        let tableViewController = TableViewController()
        tableViewController.modalPresentationStyle = UIModalPresentationStyle.Popover//UIModalPresentationPopover
        let popPC = tableViewController.popoverPresentationController!
        popPC.permittedArrowDirections = UIPopoverArrowDirection.Any
        popPC.barButtonItem = self.navigationItem.rightBarButtonItem//UIBarButtonItem(title: "test", style: UIBarButtonItemStyle.Done, target: self, action: "showPopAlert:")
        popPC.delegate = self
        popPC.sourceView = sender
        popPC.sourceRect = sender.bounds
        self.presentViewController(tableViewController, animated: true,completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
//        return UIModalPresentationStyle.Custom
    }
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let nc = UINavigationController(rootViewController: controller.presentedViewController)
        return nc
    }
    
    /*
    //开始拍照
    -(void)takePhoto
    {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //设置拍照后的图片可被编辑
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [picker release];
    [self presentModalViewController:picker animated:YES];
    }else
    {
    NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
    }
    */
    func takePhoto(){
        let sourceType = UIImagePickerControllerSourceType.Camera
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            self.presentViewController(picker, animated: true, completion: nil)
            
        }else{
            NSLog("模拟器中无法打开照相机,请在真机中使用")
        }
    }
    /*
    -(void)LocalPhoto
    {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
    [picker release];
    }
    */
    func localPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.presentViewController(picker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        NSLog("didFinishPickingImage")
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        NSLog("didFinishPickingMediaWithInfo")
        let type = info[UIImagePickerControllerMediaType] as! String
        
        if(type == "public.image"){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.pickVIew.image = image
        }
        NSLog("type = \(type)")
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        NSLog("imagePickerControllerDidCancel")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
