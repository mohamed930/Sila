//
//  ViewController.swift
//  Sila سيلا
//
//  Created by Mohamed Ali on 4/21/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    
    @IBOutlet weak var Container: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Container.loadGif(name: "GIF-200421_143932")
    }
    
    
    
}

