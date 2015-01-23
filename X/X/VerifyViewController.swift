//
//  VerifyViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class VerifyViewController: BackgroundViewController {

    @IBOutlet weak var bottomLayoutConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var domainLabel: UILabel!
    var code = 0
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set border color
        emailText.layer.cornerRadius = 4.0
        emailText.layer.masksToBounds = true
        emailText.layer.borderColor = UIColor.grayColor().CGColor
        emailText.layer.borderWidth = 1

        // set round button
        sendButton.layer.cornerRadius = 5.0
        sendButton.layer.frame = CGRectInset(sendButton.frame, 1, 1)
        
        domainLabel.text = "@\(User.currentUser().domain).edu"
        
        // generate code
        self.code = Int(arc4random()) % 9000 + 1000;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        emailText.becomeFirstResponder()
        
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
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        emailText.becomeFirstResponder()
    }

    
    @IBAction func verifyClicked(sender: AnyObject) {
        let email_main = emailText.text
        
        if email_main.isEmpty {
            return
        }
        
        self.email = "\(email_main)@\(User.currentUser().domain).edu"
        
        println(self.email)
        
        let params = ["code": self.code, "email": self.email]
        PFCloud.callFunctionInBackground("sendVerificationCode", withParameters: params) { (res, err) -> Void in
            if err == nil {
                self.performSegueWithIdentifier("show_code_input", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "show_code_input") {
            let vc = segue.destinationViewController as InputViewController
            vc.code = self.code
            vc.email = self.email
            vc.parent = self
        }
    }
    
    
    @IBAction func cancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
