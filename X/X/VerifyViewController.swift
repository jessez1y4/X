//
//  VerifyViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var domainLabel: UILabel!
    var code = 0
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        domainLabel.text = "@\(User.currentUser().domain).edu"
        
        // generate code
        self.code = Int(arc4random()) % 9000 + 1000;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        emailText.becomeFirstResponder()
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
        }
    }

}
