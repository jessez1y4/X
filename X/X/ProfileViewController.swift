//
//  ProfileViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class ProfileViewController: BackgroundViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as ProfileTableViewCell
            cell.verifyBtn.layer.cornerRadius = 20
            cell.verifyBtn.layer.frame = CGRectInset(cell.verifyBtn.frame, 20, 20)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("RecordCell") as RecordTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as SettingTableViewCell
            return cell
        }
        
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func changeSchoolClicked(sender: AnyObject) {
    }
    

    @IBAction func verifySchoolClicked(sender: AnyObject) {
    }

}
