//
//  EditViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class EditViewController: BackgroundViewController {


    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomLayoutConstrain: NSLayoutConstraint!
    @IBOutlet weak var newDomainText: UITextField!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set border color
        newDomainText.layer.cornerRadius = 4.0
        newDomainText.layer.masksToBounds = true
        newDomainText.layer.borderColor = UIColor.grayColor().CGColor
        newDomainText.layer.borderWidth = 1
        
        // set round button
        changeBtn.layer.cornerRadius = 5.0
        changeBtn.layer.frame = CGRectInset(changeBtn.frame, 1, 1)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        newDomainText.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }
    
    // MARK: - Private
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        var animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as NSNumber).unsignedIntValue << 16
        let animationCurve = UIViewAnimationOptions.init(UInt(rawAnimationCurve))
        bottomLayoutConstrain.constant = CGRectGetMaxY(view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame) + 60
        
        UIView.animateWithDuration(0.0001, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    

    @IBAction func changeClicked(sender: AnyObject) {
        let domain = newDomainText.text
        
        if domain.isEmpty {
            return
        }
        
        PFCloud.callFunctionInBackground("getCollege", withParameters: ["domain": domain]) { (res, err) -> Void in
            if err == nil {
                if let id = res as? String {
                    let user = User.currentUser()
                    user.college = College(withoutDataWithObjectId: id)
                    user.domain = domain
                    
                    User.currentUser().saveInBackgroundWithBlock(nil)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func valueChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            titleLabel.text = "Enter your new school"
            domainLabel.text = ".edu";
        case 1:
            titleLabel.text = "Enter your new company"
            domainLabel.text = ".com";
        default:
            break; 
        }
    }
    
}
