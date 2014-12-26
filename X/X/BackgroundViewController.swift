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
//        backgroundImageView.image = backgroundImage
//        backgroundView = UIView(frame: view.frame)
//        backgroundView.backgroundColor = UIColor(red: 43, green: 43, blue: 50, alpha: 0.5)
//        view.addSubview(backgroundImageView)
//        view.addSubview(backgroundView)
//        view.sendSubviewToBack(backgroundView)
        
        
        
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(context);
//        
//        // Draw picture first
//        //
//        CGContextDrawImage(context, self.frame, self.image.CGImage);
//        
//        // Blend mode could be any of CGBlendMode values. Now draw filled rectangle
//        // over top of image.
//        //
//        CGContextSetBlendMode (context, kCGBlendModeMultiply);
//        CGContextSetFillColor(context, CGColorGetComponents(self.overlayColor.CGColor));
//        CGContextFillRect (context, self.bounds);
//        CGContextRestoreGState(context);
        
        //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
//        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
//        [tintColor setFill];
//        CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
//        UIRectFill(bounds);
//        
//        //Draw the tinted image in context
//        [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
//        
//        UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        return tintedImage;
        
        
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        
        let color = UIColor(red: 43, green: 43, blue: 250, alpha: 1)
//        color.setFill()
//        let bounds = view.frame
//        UIRectFill(bounds)
        
//        backgroundImage?.drawInRect(bounds, blendMode: kCGBlendModeOverlay, alpha: 0.2)
        
        let context = UIGraphicsGetCurrentContext()
//        CGContextSaveGState(context)
//        CGContextTranslateCTM(context, 0, -view.frame.size.height);
//        CGContextScaleCTM(context, 1.0, -1.0);


        CGContextSetFillColor(context, CGColorGetComponents(color.CGColor))
        CGContextFillRect(context, view.frame)
        
                CGContextSetBlendMode(context, kCGBlendModeOverlay)
                CGContextDrawImage(context, view.frame, backgroundImage?.CGImage)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        backgroundImageView.image = img
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
//        CGContextRestoreGState(context)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
