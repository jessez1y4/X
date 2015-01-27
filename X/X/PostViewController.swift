//
//  PostViewController.swift
//  X
//
//  Created by yue zheng on 12/15/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class PostViewController: BackgroundViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomLayoutConstrain: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var parent: TimelineViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.layer.cornerRadius = 5.0
        postButton.clipsToBounds = true
        
//        textView.placeholder = "What happened?"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        self.view.endEditing(true)
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
        bottomLayoutConstrain.constant = CGRectGetMaxY(view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame) + 10
        
        UIView.animateWithDuration(0.0001, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Limit the charactor to 140
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text.utf16Count == 0 {
            if textView.text.utf16Count != 0 {
                return true
            } else {
                return false
            }
        } else if textView.text.utf16Count > 139
        {
            return false
        }
        return true
    }

    
    func textViewDidChange(textView: UITextView) {
        let count = 140 - textView.text.utf16Count
        countLabel.text = "\(count) left"
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
    }
    
    func textViewDidEndEditing(textView: UITextView) {
    }
    
    override func viewDidAppear(animated: Bool) {
        println("viewdidappear")
        super.viewDidAppear(animated)
    }


    @IBAction func postClicked(sender: AnyObject) {
        let post = Post.initWith(textView.text)
        
        post.saveInBackgroundWithBlock { (success, err) -> Void in
            if (success) {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.parent.reloadPosts(nil)
                })
            }
        }
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
