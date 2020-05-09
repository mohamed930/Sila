//
//  HomeViewController.swift
//  Sila سيلا
//
//  Created by Mohamed Ali on 4/21/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class HomeViewController: UIViewController {
    
    var homeview:HomeView! {
        guard isViewLoaded else { return nil }
        return (view as! HomeView)
    }
    
    var Email = ""
    var password = ""
    var Message = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        homeview.ImageBakcground.loadGif(name: "GIF-200421_143932")
        
        // This Method for getting predecte.
        sendNotification()
    }
    
    func getPredicte() {
        
        let p : [String:String] = ["fn":Email,"pn":password,"vv":"1"]
        
        SVProgressHUD.show()
        
        AF.request("https://www.safnah.com/hrhtest/IOS/nn.php", method: .get, parameters: p).responseJSON {
            response in
            
            switch response.result{
                
                case .success(let pp):
                                        
                    let json = JSON(pp)
                    
                    self.pareseJSON(json:json)
                
                    break
                case .failure(_):
                    
                    break
                
            }
        }
        
        
    }
    
    func pareseJSON(json:JSON){
        homeview.TowerImage.image = UIImage(named: json["borg"].stringValue)
        homeview.YourTowerMessage.text = json["daily"].stringValue
        homeview.UserNameLabel.text = json["Name"].stringValue
        
        SVProgressHUD.dismiss()
        ProgressHUD.showSuccess("تم تسجيل الدخول بنجاح")
    }
    
    func sendNotification () {
        
        let p : [String:String] = ["fn":Email,"pn":password,"vv":"2"]
        
        AF.request("https://www.safnah.com/hrhtest/IOS/nn.php", method: .get, parameters: p).responseJSON {
                   response in
                   
                   switch response.result{
                       
                       case .success(let pp):
                                               
                           let json = JSON(pp)
                           
                           
                           if json == "XXX"{
                               self.Message = "none"
                               self.getPredicte()
                           }
                           else {
                               self.Message = json["txt"].stringValue
                               Tools.createAlert(Title: "", Mess: self.Message, ob: self)
                               self.getPredicte()
                           }
                       
                           break
                       case .failure(_):
                           
                           break
                       
                   }
               }

    }
    
    @IBAction func BTNBack (_sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BTNSendLetter() {
        self.performSegue(withIdentifier: "SendLetter", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendLetter"{
            let vc = segue.destination as! SendLetterViewController
            vc.email = Email
            vc.Name = homeview.UserNameLabel.text!
        }
    }
    
    // TODO: This Action Method For Facebook Button.
    @IBAction func BTNFacebook(_ sender:Any){
        Tools.openSafari(url: "https://m.facebook.com/ammaraldewani/", ob: self)
    }
    
    // TODO: This Action Method For Twitter Button.
    @IBAction func BTNTwitter(_ sender:Any){
        Tools.openSafari(url: "https://mobile.twitter.com/acfe2005", ob: self)
    }
    
    // TODO: This Action Method For What'sApp Button.
    @IBAction func BTNWhatsapp(_ sender:Any){
        Tools.openSafari(url: "https://api.whatsapp.com/send?phone=+905362301563", ob: self)
    }
    
    // TODO: This Action Method For Instegram Button.
    @IBAction func BTNInstegram(_ sender:Any){
        Tools.openSafari(url: "https://www.instagram.com/ammaraldewani/", ob: self)
    }
}
