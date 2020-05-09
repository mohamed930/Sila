//
//  Tools.swift
//  Silia
//
//  Created by Mohamed Ali on 4/22/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import Foundation
import SafariServices

class Tools {
    
    public static func openSafari(url:String , ob:UIViewController) {
        
        let safariVC = SFSafariViewController(url: URL(string: url)!)
        ob.present(safariVC, animated: true)
    }
    
    public static func createAlert (Title:String , Mess:String , ob:UIViewController)
    {
        let alert = UIAlertController(title: Title , message:Mess
            , preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        ob.present(alert,animated:true,completion: nil)
    }
    
    public static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
