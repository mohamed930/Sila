//
//  SignInViewController.swift
//  Sila سيلا
//
//  Created by Mohamed Ali on 4/21/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import CoreData

class SignInViewController: UIViewController {
    
    var signinview: SignInView! {
        guard isViewLoaded else { return nil }
        return (view as! SignInView)
    }
    
    // Varibles we used in this form
    var UserName = ""
    var UsersArray = [UserData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getDataFormCoreData()
        if UsersArray.count != 0 {
            // Read Data From CoreData And Login
            signinview.EmailTextField.text = UsersArray[0].useremail
            signinview.PasswordTextField.text = UsersArray[0].password
        }
    }
    
    @IBAction func BTNBack(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    // TODO: This Method For Fetch All Data.
    func getDataFormCoreData() {
        let fetchrequest:NSFetchRequest<UserData> = UserData.fetchRequest()
        do {
            UsersArray = try! context.fetch(fetchrequest)
        }
    }
    
    @IBAction func BTNSignIng(_ sender:Any){
        
        if signinview.EmailTextField.text == "" || signinview.PasswordTextField.text == "" {
            Tools.createAlert(Title: "خطا", Mess: "من فضلك املئ جميع الحقول", ob: self)
        }
        else{
            GetData()
        }
        
    }
    
    func GetData() {
        
        SVProgressHUD.show()
        
        let p = ["fn":signinview.EmailTextField.text!,"pn":signinview.PasswordTextField.text!]
        
        AF.request("https://www.safnah.com/hrhtest/IOS/r.php", method: .get, parameters: p).responseJSON {
            response in
            
            switch response.result{
                
                case .success(let pp):
                                        
                    let json = JSON(pp)
                    self.parseJSON(json:json)
                
                    break
                case .failure(_):
                    
                    break
                
            }
        }
    }
    
    func parseJSON(json:JSON) {
        
        if json == "XXX"{
            SVProgressHUD.dismiss()
            ProgressHUD.showError("خطا لم نتمكن من ايجاد بريدك الالكتروني")
            self.signinview.PasswordTextField.text = ""
        }
        else{
            SVProgressHUD.dismiss()
           // print("UserName: \(json["Name"].stringValue)")
            UserName = json["Name"].stringValue
            
            if self.UsersArray.count == 0 {
                // Save On CoreData Normally
                let ob = UserData(context: context)
                ob.useremail = self.signinview.EmailTextField.text!
                ob.password = self.signinview.PasswordTextField.text!
                ad.saveContext()
                self.performSegue(withIdentifier: "SignInGo", sender: self)
            }
            else if self.UsersArray.count == 1 {
                // There is Element In The CoreData.
                self.UsersArray[0].setValue(self.signinview.EmailTextField.text!, forKey: "useremail")
                self.UsersArray[0].setValue(self.signinview.PasswordTextField.text!, forKey: "password")
                ad.saveContext()
                self.performSegue(withIdentifier: "SignInGo", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInGo" {
            let vc = segue.destination as! HomeViewController
            vc.Email = self.signinview.EmailTextField.text!
            vc.password = self.signinview.PasswordTextField.text!
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.signinview.endEditing(true)
    }
}


extension SignInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.signinview.endEditing(true)
        return true
    }
}
