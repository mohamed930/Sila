//
//  SendLetterViewController.swift
//  Sila سيلا
//
//  Created by Mohamed Ali on 4/21/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SendLetterViewController: UIViewController {
    
    var type:Bool?
    var Name = ""
    var email = ""
    
    var sendletterview: SendLetterView! {
        guard isViewLoaded else { return nil }
        return (view as! SendLetterView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sendletterview.DatePickerView.layer.backgroundColor = UIColor.white.cgColor
        sendletterview.DatePickerView.layer.cornerRadius = 10.0
        sendletterview.TimePickerView.layer.backgroundColor = UIColor.white.cgColor
        sendletterview.TimePickerView.layer.cornerRadius = 10.0
        
        sendletterview.Scroll.keyboardDismissMode = .interactive
        //put this where you initialize your scroll view
        let theTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        sendletterview.Scroll.addGestureRecognizer(theTap)
    }
    
    @IBAction func BTNBack (_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BTNRadio1 (_ sender:UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sendletterview.BTNRadio2.isSelected = false
            self.type = true
            print("type is \(self.type!)")
        }
        else {
            sender.isSelected = true
            sendletterview.BTNRadio2.isSelected = false
            self.type = true
            print("type is \(self.type!)")
        }
        
    }
    
    @IBAction func BTNRadio2 (_ sender:UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            sendletterview.BTNRadio.isSelected = false
            self.type = false
            print("type is \(self.type!)")
        }
        else {
            sender.isSelected = true
            sendletterview.BTNRadio.isSelected = false
            self.type = false
            print("type is \(self.type!)")
        }
        
    }
    
    @IBAction func SendRequest(_ sender:Any){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let date = sendletterview.DatePickerView.date
        let formateDate = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH"
        let formateDate1 = dateFormatter.string(from: sendletterview.TimePickerView.date)
        
        dateFormatter.dateFormat = "mm"
        let formateDate2 = dateFormatter.string(from: sendletterview.TimePickerView.date)
        
        
        if (sendletterview.PlaceBirth.text == "" || formateDate == "" || formateDate1 == "" || formateDate2 == "" || self.type == nil) {
            Tools.createAlert(Title: "خطا", Mess: "ارجوك املئ كل الحقول", ob: self)
        }
        else {
            SendData()
        }
        
    }
    
    func SendData() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let date = sendletterview.DatePickerView.date
        let formateDate = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH"
        let formateDate1 = dateFormatter.string(from: sendletterview.TimePickerView.date)
        
        dateFormatter.dateFormat = "mm"
        let formateDate2 = dateFormatter.string(from: sendletterview.TimePickerView.date)
        
        let place = self.sendletterview.PlaceBirth.text!
        let t1 = String(self.type!)
        
        print("place \(place)")
        
        
        SVProgressHUD.show()
        
        AF.upload(multipartFormData: { (multipartFormData) in
                   
                  multipartFormData.append("\(self.Name)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "fn")
                            
                            multipartFormData.append("\(self.email)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "nn")
                            
                            multipartFormData.append("\(t1)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "gg")
                            
                            multipartFormData.append("\(formateDate)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "dob")
                            
                            multipartFormData.append("\(formateDate1)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "hh")
                            
                            multipartFormData.append("\(formateDate2)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "mm")
                            
                            multipartFormData.append("\(place)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "cc")

                       
                      }, to: "https://www.safnah.com/hrhtest/IOS/req.php", method: .post, headers: nil){ (response) in
                    
                            SVProgressHUD.dismiss()
                            ProgressHUD.showSuccess("تم ارسال طلبك بنجاح")
            
                      }
        
    }
    
    //This can go anywhere in your class
    @objc func scrollViewTapped(recognizer: UIGestureRecognizer) {
        sendletterview.Scroll.endEditing(true)
    }
    // ---------------------------------------------------------
}


extension SendLetterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendletterview.endEditing(true)
        return true
    }
    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.sendletterview.ScrollHeight.constant = 270
            self.sendletterview.layoutIfNeeded()
        }
    }
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.sendletterview.ScrollHeight.constant = 0
            self.sendletterview.layoutIfNeeded()
        }
    }
}
