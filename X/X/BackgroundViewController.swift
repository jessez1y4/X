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
//    var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill

        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        view.backgroundColor = UIColor(red: 43/255.0, green: 43/255.0, blue: 50/255.0, alpha: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if Variable.backgroundImage == nil {
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDirectory = paths[0] as String
            let getImagePath = documentsDirectory.stringByAppendingPathComponent("BG.jpg")
            let img = UIImage(contentsOfFile: getImagePath)
            
            if img == nil {
                Variable.backgroundImage = UIImage(named: "BG.png")
            } else {
                Variable.backgroundImage = img
            }
        }
        
        backgroundImageView.image = imageWithAlpha(Variable.backgroundImage!, alpha: 0.1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageWithAlpha(image: UIImage, alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRectMake(0, 0, image.size.width, image.size.height)
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -area.size.height)
        
        CGContextSetAlpha(context, alpha)
        CGContextDrawImage(context, area, image.CGImage)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
