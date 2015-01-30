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
    
    @IBOutlet weak var codeContainer: UIView!
    
    var labels: [UILabel!] = []
    var code: Int!
    var email: String!
    var parent: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this part setting the custom back button with swiping
        let backImage = UIImage(named: "Icon_Back@2x.png")
        var newBackButton = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Bordered, target: self, action: "goBack")
        self.navigationItem.setLeftBarButtonItem(newBackButton, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        self.navigationController?.interactivePopGestureRecognizer.delegate = self
        // end

        var spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
//        codeText.leftViewMode = UITextFieldViewMode.Always
//        codeText.leftView = spacerView
        
        // Do any additional setup after loading the view.
        msgLabel.text = "Please enter the 4-digit number we just sent to \(self.email)"
        println(self.code)
        self.labels = [self.label1, self.label2, self.label3, self.label4]
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
                user.saveInBackgroundWithBlock({ (succeed, error) -> Void in
                    if succeed {
                        // pop 2 view to profileViewController
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
                    }
                })
                
            } else {
                println("wrong code")
                self.shakeView()
            }
        }
        
        if len < 4 {
            for idx in len...3 {
                labels[idx]!.text = ""
            }
        }
        
        println(codeInput.text)
    }
    
    func shakeView(){
        var shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        var from_point:CGPoint = CGPointMake(codeContainer.center.x - 6, codeContainer.center.y)
        var from_value:NSValue = NSValue(CGPoint: from_point)
        
        var to_point:CGPoint = CGPointMake(codeContainer.center.x + 6, codeContainer.center.y)
        var to_value:NSValue = NSValue(CGPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        codeContainer.layer.addAnimation(shake, forKey: "position")
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
