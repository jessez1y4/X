//
//  InputViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class InputViewController: BackgroundViewController, UITextFieldDelegate {

    @IBOutlet weak var codeText: UITextField!
    var code: Int!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
//        codeText.leftViewMode = UITextFieldViewMode.Always
//        codeText.leftView = spacerView
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        codeText.becomeFirstResponder()
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
        if String(self.code) == codeText.text {
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
