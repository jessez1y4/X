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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        domainText.becomeFirstResponder()
    }
    
    
    @IBAction func loginBtnClicked(sender: AnyObject) {
        let domain = domainText.text
        
        if domain.isEmpty {
            return
        }
        
        PFCloud.callFunctionInBackground("getCollege", withParameters: ["domain": domain]) { (res, err) -> Void in
            if err == nil {
                if let id = res as? String {
                    let user = User.currentUser()
                    user.college = College(withoutDataWithObjectId: id)
                    user.domain = domain
                    user.setDefaultValues()
                    
                    User.currentUser().saveInBackgroundWithBlock(nil)
                    self.performSegueWithIdentifier("show_home", sender: self)
                }
            }
        }
        
    }
}

