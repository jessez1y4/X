//
//  ProfileViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class ProfileViewController: BackgroundViewController, DBCameraViewControllerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100

        // Do any additional setup after loading the view.
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // make the navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        super.viewWillAppear(animated)
    }
    
    
    func tableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as ProfileTableViewCell
            
            cell.avatarImageView.layer.cornerRadius = 10
            cell.avatarImageView.clipsToBounds = true
            
            cell.verifyBtn.layer.cornerRadius = 20
            cell.verifyBtn.clipsToBounds = true
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("RecordCell") as RecordTableViewCell
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as SettingTableViewCell
            if indexPath.row == 2 {
                
                cell.nameImageView.image = UIImage(named: "Icon_Settings@2x.png")
                cell.nameLabel.text = "Settings"
                
            } else if indexPath.row == 3 {
                
                cell.nameImageView.image = UIImage(named: "Icon_About@2x.png")
                cell.nameLabel.text = "About"
                
            }
            return cell
        }
        
    }
    
    
    @IBAction func changeSchoolClicked(sender: AnyObject) {
    }
    

    @IBAction func verifySchoolClicked(sender: AnyObject) {
        
    }
    
    @IBAction func avatarClicked(sender: UITapGestureRecognizer) {
        
        let cameraController = DBCameraViewController.initWithDelegate(self)
        cameraController.setForceQuadCrop(true)
        let container = DBCameraContainerViewController(delegate: self)
        container.setDBCameraViewController(cameraController)
        let nav = UINavigationController(rootViewController: container)
        nav.setNavigationBarHidden(true, animated: true)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    @IBAction func changeBGClicked(sender: AnyObject) {
        
        let cameraController = DBCameraViewController.initWithDelegate(self)
        let container = DBCameraContainerViewController(delegate: self)
        container.setFullScreenMode()
        let nav = UINavigationController(rootViewController: container)
        nav.setNavigationBarHidden(true, animated: true)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func fixrotation(image: UIImage) -> UIImage {
        if image.imageOrientation == UIImageOrientation.Up {
            return image;
        }
        
        var transform = CGAffineTransformIdentity

        transform = CGAffineTransformTranslate(transform, 0, image.size.height);
        transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2));

    
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        var ctx = CGBitmapContextCreate(nil, UInt(image.size.width), UInt(image.size.height), CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), CGImageGetBitmapInfo(image.CGImage));
        
        CGContextConcatCTM(ctx, transform);

        CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = CGBitmapContextCreateImage(ctx)
        let img = UIImage(CGImage: cgimg)
      
        return img!
    }
    
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let ratio = width/image.size.width
        
        let newSize = CGSizeMake(image.size.width*ratio,image.size.height*ratio);
        
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0,0,newSize.width,newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    

    // use corp mode to determine if it's background image change or avatar change
    func camera(cameraViewController: AnyObject!, didFinishWithImage image: UIImage!, withMetadata metadata: [NSObject : AnyObject]!) {
        
        let comingCameraViewController = cameraViewController as DBCameraSegueViewController
        
        if comingCameraViewController.cropMode == true {
            
            // avatar change
            let avatarImage = self.resizeImage(image, width: 100, height: 100)
            let avatarData = UIImageJPEGRepresentation(avatarImage, 0.9)
            User.currentUser().avatar = PFFile(data: avatarData)
            User.currentUser().saveInBackgroundWithBlock({ (succeed, error) -> Void in
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    if succeed {
//                        self.tableView.reloadData()
                        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                    }
                })
            })
            
            println("avatar change!")
        } else {
            
            let new_image = fixrotation(image)
            
            let targetWidth = UIScreen.mainScreen().bounds.size.width
            let targetHeight = UIScreen.mainScreen().bounds.size.height
            let targetRatio = targetWidth / targetHeight
            
            var cropRect: CGRect!
            
            let currWidth = new_image.size.width
            let currHeight = new_image.size.height
            let currRatio = currWidth / currHeight
            
            
            
            if currRatio > targetRatio {
                let height = currHeight
                let width = currHeight * targetRatio
                let x = (currWidth - width) / 2
                cropRect = CGRectMake(x, 0, width, height)
                
            } else {
                let width = currWidth
                let height = width / targetRatio
                let x = (currWidth - width) / 2
                cropRect = CGRectMake(x, 0, width, height)
            }
            
            let imageRef = CGImageCreateWithImageInRect(new_image.CGImage, cropRect)
            let cropped = UIImage(CGImage: imageRef)
            
            let finalImage = self.resizeImage(cropped!, width: targetWidth, height: targetHeight)

            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDirectory = paths[0] as String
            let savedImagePath = documentsDirectory.stringByAppendingPathComponent("BG.jpg")
            let imageData = UIImageJPEGRepresentation(finalImage, 0.9)
            imageData.writeToFile(savedImagePath, atomically: false)
            
            
            
            Variable.backgroundImage = finalImage
            println("background change!")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
    func dismissCamera(cameraViewController: AnyObject!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    
    


}
