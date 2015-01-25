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
    

    // use corp mode to determine if it's background image change or avatar change
    func camera(cameraViewController: AnyObject!, didFinishWithImage image: UIImage!, withMetadata metadata: [NSObject : AnyObject]!) {
        
        let comingCameraViewController = cameraViewController as DBCameraSegueViewController
        
        if comingCameraViewController.cropMode == true {
            // avatar change
            
            println("avatar change!")
        } else {
            Variable.backgroundImage = image
            println("background change!")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func dismissCamera(cameraViewController: AnyObject!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    
    


}
