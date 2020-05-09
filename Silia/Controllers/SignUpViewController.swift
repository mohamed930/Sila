//
//  SignUpViewController.swift
//  Sila سيلا
//
//  Created by Mohamed Ali on 4/21/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SignUpViewController: UIViewController {
    
    var Arr = ["اختر النوع","ذكر","انثي"]
    var type:Bool?
    var DateOfBirth: String?
    var TimeofBirth: String?
    
    var signupview : SignUpView! {
        guard isViewLoaded else { return nil }
         return (view as! SignUpView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signupview.datePickerView.layer.backgroundColor = UIColor.white.cgColor
        signupview.datePickerView.layer.cornerRadius = 10.0
        signupview.TimePickerView.layer.backgroundColor = UIColor.white.cgColor
        signupview.TimePickerView.layer.cornerRadius = 10.0
        
        signupview.Scroll.keyboardDismissMode = .interactive
        //put this where you initialize your scroll view
        let theTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        signupview.Scroll.addGestureRecognizer(theTap)
    }
    
    @IBAction func BTNBack (_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BTNRadioOne(_ sender:UIButton){
        if sender.isSelected {
            sender.isSelected = false
            signupview.RadioTwo.isSelected = false
            self.type = true
        }
        else {
            sender.isSelected = true
            signupview.RadioTwo.isSelected = false
            self.type = true
        }
        
        //sender.isSelected = !sender.isSelected
    }
    
    @IBAction func BTNRadioTwo(_ sender:UIButton){
        //sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.isSelected = false
            signupview.RadioOne.isSelected = false
            self.type = false
            print("type is \(self.type!)")
        }
        else {
            sender.isSelected = true
            signupview.RadioOne.isSelected = false
            self.type = false
            print("type is \(self.type!)")
        }
    }
    
    //This can go anywhere in your class
    @objc func scrollViewTapped(recognizer: UIGestureRecognizer) {
        signupview.Scroll.endEditing(true)
    }
    // ---------------------------------------------------------
    
    // TODO: This Method For Send Data To DataBase.
    @IBAction func BTNSendData(_ sender:Any){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let date = signupview.datePickerView.date
        let formateDate = dateFormatter.string(from: date)

        dateFormatter.dateFormat = "HH"
        let formateDate1 = dateFormatter.string(from: signupview.TimePickerView.date)

        dateFormatter.dateFormat = "mm"
        let formateDate2 = dateFormatter.string(from: signupview.TimePickerView.date)

        if (signupview.UserNameText.text == "" || signupview.EmailText.text == "" ||
            signupview.PasswordText.text == "" || signupview.ConfirmPassWordText.text == "" || signupview.PlceOfBirthText.text == "" || type == nil || formateDate == "" || formateDate1 == "" || formateDate2 == "")
        {
            Tools.createAlert(Title: "خطا", Mess: "من فضلك املي كل البيانات", ob: self)
        }
        else {
            if signupview.PasswordText.text != signupview.ConfirmPassWordText.text {
                Tools.createAlert(Title: "خطا", Mess: "كلمه المرور غير متطابقه", ob: self)
                signupview.PasswordText.text = ""
                signupview.ConfirmPassWordText.text = ""
            }
            else {
                
                let result = Tools.isValidEmail(signupview.EmailText.text!)
                if result {
                    
                    if (signupview.TelephoneText.text?.count)! < 21 {
                        self.d()
                    }
                    else {
                        Tools.createAlert(Title: "خطا", Mess: "من فضلك ادخل رقم تليفون صالح", ob: self)
                        signupview.TelephoneText.text = ""
                    }
                }
                else {
                    Tools.createAlert(Title: "خطا", Mess: "من فضلك ادخل ايميل صالح", ob: self)
                    signupview.EmailText.text = ""
                }
            }
        }
        
    }
    
    func CheckEmail(){
        
        let Email = signupview.EmailText.text!
        let Password = signupview.PasswordText.text!
        
        let p : [String:String] = ["fn":Email,"pn":Password]
        
        AF.request("https://www.safnah.com/hrhtest/IOS/r.php", method: .get, parameters: p).responseJSON {
            response in
            
            switch response.result{
                
                case .success(let pp):
                                        
                    let p = JSON(pp)
                    self.parseJSON(json:p)
                
                    break
                case .failure(_):
                    
                    break
                
            }
        }
    }
    
    func parseJSON(json:JSON){
        let Password = json["password"].stringValue
        let userName = json["Name"].stringValue
        let telephone = json["Mobile"].stringValue
        
        if Password == signupview.PasswordText.text! && telephone == signupview.TelephoneText.text && userName == signupview.UserNameText.text!{
            SVProgressHUD.dismiss()
            ProgressHUD.showSuccess("تمت اضافه الحساب بنجاح")
        }
        else {
            SVProgressHUD.dismiss()
            ProgressHUD.showError("هذا الحساب مستخدم بالفعل")
        }
    }
    
    // TODO: This Method For Sending Data To API.
    func d() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let date = signupview.datePickerView.date
        let formateDate = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH"
        let formateDate1 = dateFormatter.string(from: signupview.TimePickerView.date)
        
        dateFormatter.dateFormat = "mm"
        let formateDate2 = dateFormatter.string(from: signupview.TimePickerView.date)
        
        let Name = self.signupview.UserNameText.text!
        let Password = self.signupview.PasswordText.text!
        let email = self.signupview.EmailText.text!
        let tele = self.signupview.TelephoneText.text!
        let place = self.signupview.PlceOfBirthText.text!
        
        print("Name \(Name)")
        print("password \(Password)")
        print("email \(email)")
        print("tele \(tele)")
        print("type \(String(type!))")
        print("place \(place)")
        
        SVProgressHUD.show()
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append("\(email)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "fn")

            multipartFormData.append("\(Password)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "pn")

            multipartFormData.append("\(Name)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "nn")

            multipartFormData.append("\(String(self.type!))".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "gg")

            multipartFormData.append("\(tele)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "mob")

            multipartFormData.append("\(formateDate)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "dob")

            multipartFormData.append("\(formateDate1)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "hh")

            multipartFormData.append("\(formateDate2)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "mm")

            multipartFormData.append("\(place)".data(using: String.Encoding.utf8,allowLossyConversion: false)!, withName: "cc")

                
               }, to: "https://www.safnah.com/hrhtest/IOS/i.php", method: .post, headers: nil).responseJSON { (response) in
                      let result = response.result

                      switch result {
                      case .success(_):
                        SVProgressHUD.dismiss()
                            self.CheckEmail()
                        break
                          
                      case .failure(let error):
                         SVProgressHUD.dismiss()
                         self.CheckEmail()
                          print(error)
                        break
                      }
               }
        
        

    }
}
        

extension SignUpViewController: UITextFieldDelegate {
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.signupview.ScrollHieght.constant = 270
            self.signupview.layoutIfNeeded()
        }
    }
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.signupview.ScrollHieght.constant = 0
            self.signupview.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
