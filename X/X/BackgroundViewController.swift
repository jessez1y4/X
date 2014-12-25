//
//  BackgroundViewController.swift
//  X
//
//  Created by yue zheng on 12/25/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class BackgroundViewController: UIViewController {
    
    var backgroundImageView: UIImageView!
    var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var backgroundImage = UIImage(named: "mushi.jpg")
        backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.image = backgroundImage
        backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor(red: 43, green: 43, blue: 50, alpha: 0.8)
        view.addSubview(backgroundImageView)
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundImageView)
        view.sendSubviewToBack(backgroundView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
