//
//  InfoViewController.swift
//  Sila سيلا
//
//  Created by Mohamed Ali on 4/21/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // TODO: This Action Method For Button Back.
    @IBAction func BTNBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // TODO: This Action For Download PDF.
    @IBAction func BTNDownloadPDF(_ sender:Any){
        Tools.openSafari(url: "https://up4net.com/uploads/up4net-falak.pdf", ob: self)
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
