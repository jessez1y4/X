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
        
//        var logoImage = UIImage(named: "bicon.png")
//        var backCircleImage = UIImage(named: "light_circle.png")
//        var frontCircleImage = UIImage(named: "dark_circle.png")
//        var progressView = BMYCircularProgressView(frame: CGRectMake(0, 0, 25, 25), logo: logoImage, backCircleImage: backCircleImage, frontCircleImage: frontCircleImage)
//        
//        self.tableView.setPullToRefreshWithHeight(10, actionHandler: { (pullToRefreshView: BMYPullToRefreshView!) -> Void in
//            
//            
//            // reload data ...
//            
//            self.college.getPosts({ (posts, err) -> Void in
//                if err == nil && posts.first?.objectId != self.posts.first?.objectId {
//                    self.posts = posts
//                    self.tableView.reloadData()
//                }
//                pullToRefreshView.stopAnimating()
//                
//            })
//        })
//        
//        tableView.pullToRefreshView.preserveContentInset = true
//        tableView.pullToRefreshView.setProgressView(progressView)

        let backgroundImage = UIImage(named: "BG.png")
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.image = imageWithAlpha(backgroundImage!, alpha: 0.1)
        view.addSubview(backgroundImageView)
        
        view.sendSubviewToBack(backgroundImageView)
        view.backgroundColor = UIColor(red: 43/255.0, green: 43/255.0, blue: 50/255.0, alpha: 1)
        
        self.tableView.backgroundColor = UIColor.clearColor()
        
        
        
        self.bounces = true
        self.shakeToClearEnabled = true
        self.keyboardPanningEnabled = true
        self.shouldScrollToBottomAfterKeyboardShows = false
        self.inverted = false

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        
        self.tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "replyCell")
        
        // add constraints for tableView
        
        
        self.textView.placeholder = "What do you think?"
        self.textView.placeholderColor = UIColor.grayColor()
        

            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "OpenSans", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
//        self.textView.layer.borderColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
//        self.textView.pastableMediaTypes = SLKPastableMediaTypeAll|SLKPastableMediaTypePassbook;
        
//        [self.leftButton setImage:[UIImage imageNamed:@"icn_upload"] forState:UIControlStateNormal];
//        [self.leftButton setTintColor:[UIColor grayColor]];
        
        self.rightButton.setTitle("Send", forState: UIControlState.Normal)
        
//        [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
//        [self.textInputbar.editortLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
//        [self.textInputbar.editortRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
        
        self.textInputbar.autoHideRightButton = true
        self.textInputbar.maxCharCount = 140
        self.textInputbar.counterStyle = SLKCounterStyle.Split
        
//        self.typingIndicatorView.canResignByTouch = YES;
        
//        [self.autoCompletionView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:AutoCompletionCellIdentifier];
//        [self registerPrefixesForAutoCompletion:@[@"@", @"#", @":"]];

        
        // initial load
        self.reloadReplies()
        
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
        return self.replies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("replyCell") as MessageTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        let reply = self.replies[indexPath.row]
        
        cell.textLabel!.text = reply.content
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: "OpenSans-light", size: 15)
        
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
            }
        }
    }
    @IBAction func backClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)

    }
}

