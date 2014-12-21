//
//  VerifyViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {

    @IBOutlet weak var newDomainText: UITextField!
    
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
        newDomainText.becomeFirstResponder()
    }

    
    @IBAction func verifyClicked(sender: AnyObject) {
    }

}
