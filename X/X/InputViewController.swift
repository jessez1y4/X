//
//  InputViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class InputViewController: BackgroundViewController, UITextFieldDelegate {

    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var codeInput: UITextField!

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    
    var labels: [UILabel!] = []
    var code: Int!
    var email: String!
    var parent: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
//        codeText.leftViewMode = UITextFieldViewMode.Always
//        codeText.leftView = spacerView
        
        // Do any additional setup after loading the view.
        msgLabel.text = "Please enter the 4-digit number we just sent to \(self.email)"
        println(self.code)
        self.labels = [self.label1, self.label2, self.label3, self.label4]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        codeInput.becomeFirstResponder()
    }
    
    @IBAction func codeInputChanged(sender: AnyObject) {
        
        
        let array = Array(codeInput.text)
        var len = array.count
        
        if len > 4 {
            len = 4
            codeInput.text = (codeInput.text as NSString).substringToIndex(4)
            return
        }
        
        if len > 0 {
            for idx in 0...len - 1 {
                labels[idx]!.text = String(array[idx])
            }
        }
        
        if len == 4 {
            if String(self.code) == codeInput.text {
                println("verified")
                
                let user = User.currentUser()
                user.email = self.email
                user.verified = true
                user.saveEventually()
                
                
                self.dismissViewControllerAnimated(false, completion: nil)
                self.parent.dismissViewControllerAnimated(false, completion: nil)
            } else {
                println("wrong code")
            }
        }
        
        if len < 4 {
            for idx in len...3 {
                labels[idx]!.text = ""
            }
        }
        
        println(codeInput.text)
    }
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        <#code#>
//    }
//    
//    - (void)selectTextInTextField:(UITextField *)textField range:(NSRange)range {
//    UITextPosition *from = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location];
//    UITextPosition *to = [textField positionFromPosition:from offset:range.length];
//    [textField setSelectedTextRange:[textField textRangeFromPosition:from toPosition:to]];
//    }
    
    @IBAction func doneClicked(sender: AnyObject) {
        if String(self.code) == codeInput.text {
            println("verified")
            
            let user = User.currentUser()
            user.email = self.email
            user.verified = true
            user.saveInBackgroundWithBlock({ (success, err) -> Void in
                if success {
                    println("saved user in cloud")
                }
            })
        }
    }

    @IBAction func cancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

}
