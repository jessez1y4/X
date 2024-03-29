//
//  ViewController.swift
//  X
//
//  Created by Yu Jiang on 12/14/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class PostDetailViewController: SLKTextViewController {
    
    var post: Post!
    var replies: [Reply] = []
    var backgroundImageView: UIImageView!

    
    override init() {
        super.init(tableViewStyle: UITableViewStyle.Plain)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        backgroundImageView = UIImageView(frame: view.frame)
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        view.backgroundColor = UIColor(red: 43/255.0, green: 43/255.0, blue: 50/255.0, alpha: 1)
        
        self.bounces = true
        self.shakeToClearEnabled = true
        self.keyboardPanningEnabled = true
        self.shouldScrollToBottomAfterKeyboardShows = false
        self.inverted = false

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "replyCell")
        
        // add constraints for tableView
        
        
        self.textView.placeholder = "What do you think?"
        self.textView.placeholderColor = UIColor.grayColor()
        

        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "OpenSans", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.rightButton.setTitle("Send", forState: UIControlState.Normal)
        
        self.textInputbar.autoHideRightButton = true
        self.textInputbar.maxCharCount = 140
        self.textInputbar.counterStyle = SLKCounterStyle.Split

        // initial load
        self.reloadReplies()
        
        if post.user.objectId == User.currentUser().objectId {
            post.unread = 0
            post.saveEventually()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.edgesForExtendedLayout = UIRectEdge.None

        // this part setting the custom back button with swiping
        let backImage = UIImage(named: "Icon_Back@2x.png")
        var newBackButton = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Bordered, target: self, action: "goBack")
        self.navigationItem.setLeftBarButtonItem(newBackButton, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        self.navigationController?.interactivePopGestureRecognizer.delegate = self
        // end
        
        backgroundImageView.image = imageWithAlpha(Variable.backgroundImage!, alpha: 0.1)
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill

        }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func imageWithAlpha(image: UIImage, alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRectMake(0, 0, image.size.width, image.size.height)
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -area.size.height)
        
        CGContextSetAlpha(context, alpha)
        CGContextDrawImage(context, area, image.CGImage)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableViewStyleForCoder(decoder: NSCoder) -> UITableViewStyle {
        return UITableViewStyle.Plain
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replies.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("replyCell") as MessageTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: "OpenSans-light", size: 15)
        
        if indexPath.row == 0 {
            cell.textLabel!.text = post.content
            
        } else {
            let reply = self.replies[indexPath.row - 1]
            cell.textLabel!.text = reply.content

        }
        return cell

    }
    
    func reloadReplies() {
        self.post.getReplies({ (replies, err) -> Void in
            if err == nil {
                self.replies = replies
                self.tableView.reloadData()
            }
        })
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        println("sending reply")
        let reply = Reply.initWith(post, content: self.textView.text)
        reply.saveInBackgroundWithBlock { (success, err) -> Void in
            if success {
                self.textView.text = ""
                self.reloadReplies()
                
                if self.post.user.objectId != User.currentUser().objectId {
                    self.post.incrementKey("unread")

                    
                    let relation = User.currentUser().relationForKey("replied")
                    let query = relation.query()
                    query.whereKey("objectId", equalTo: self.post.objectId)
                    
                    query.countObjectsInBackgroundWithBlock({ (count, error) -> Void in
                        if error == nil && count == 0 {
                            self.post.incrementKey("life", byAmount: User.currentUser().voteWeight)
                            User.currentUser().addRelation(self.post, relation: "replied")
                            User.currentUser().saveEventually()
                        }
                        
                        self.post.saveEventually()
                    })

                }
                

                
                self.post.user.fetchIfNeededInBackgroundWithBlock({ (result, error) -> Void in
                    if error == nil {
                        let user = result as User
                        if self.replies.count > user.mostReplies {
                            user.mostReplies = self.replies.count
                            user.saveEventually()
                        }
                    }
                })
            }
        }
    }
    
//    @IBAction func backClicked(sender: AnyObject) {
//        self.navigationController?.popViewControllerAnimated(true)
//
//    }
}

