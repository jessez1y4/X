//
//  PostViewController.swift
//  X
//
//  Created by yue zheng on 12/15/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        println("changed!")
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        println("end!")
    }
    
    override func viewDidAppear(animated: Bool) {
        println("viewdidappear")
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @IBAction func doneClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
