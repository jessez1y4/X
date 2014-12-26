//
//  InputViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet weak var codeText: UITextField!
    var code: Int!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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


}
