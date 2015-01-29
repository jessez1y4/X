//
//  EditViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class EditViewController: BackgroundViewController, UIGestureRecognizerDelegate {


    @IBOutlet weak var newDomainText: UITextField!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this part setting the custom back button with swiping
        let backImage = UIImage(named: "Icon_Back@2x.png")
        var newBackButton = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Bordered, target: self, action: "goBack")
        self.navigationItem.setLeftBarButtonItem(newBackButton, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.interactivePopGestureRecognizer.delegate = self
        // end
        
        // set border color
        newDomainText.layer.cornerRadius = 4.0
        newDomainText.layer.masksToBounds = true
        newDomainText.layer.borderColor = UIColor.grayColor().CGColor
        newDomainText.layer.borderWidth = 1
        
        // set round button
        changeBtn.layer.cornerRadius = 5.0
        changeBtn.layer.frame = CGRectInset(changeBtn.frame, 1, 1)
        
        newDomainText.tintColor = UIColor.whiteColor()

        // Do any additional setup after loading the view.
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        newDomainText.becomeFirstResponder()
//        newDomainText.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        newDomainText.becomeFirstResponder()

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
        bottomLayoutConstraint.constant = CGRectGetMaxY(view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame) + 14
        
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
                    user.verified = false
                    
                    User.currentUser().saveInBackgroundWithBlock(nil)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    
    }

    
}
