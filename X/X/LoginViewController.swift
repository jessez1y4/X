import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var domainText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginBtnClicked(sender: AnyObject) {
        if domainText.text.isEmpty {
            return
        }
        
        PFCloud.callFunctionInBackground("getCollege", withParameters: ["domain": domainText.text]) { (res, err) -> Void in
            if err == nil {
                if let id = res as? String {
                    User.currentUser().college = College(withoutDataWithObjectId: id)
                    User.currentUser().saveInBackgroundWithBlock(nil)
                    self.performSegueWithIdentifier("show_home", sender: self)
                }
            }
        }
        
    }
}

