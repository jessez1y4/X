//
//  ViewController.swift
//  X
//
//  Created by Yu Jiang on 12/14/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class TimelineViewController: BackgroundViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var timelineTableView: UITableView!
    @IBOutlet weak var tableMaskView: UIView!
    
    var college = User.currentUser().college
    var posts: [Post] = []
    var maskLayer: CAGradientLayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var logoImage = UIImage(named: "bicon.png")
        var backCircleImage = UIImage(named: "light_circle.png")
        var frontCircleImage = UIImage(named: "dark_circle.png")
        var progressView = BMYCircularProgressView(frame: CGRectMake(0, 0, 25, 25), logo: logoImage, backCircleImage: backCircleImage, frontCircleImage: frontCircleImage)
        
        self.timelineTableView.setPullToRefreshWithHeight(60.0, actionHandler: { (pullToRefreshView: BMYPullToRefreshView!) -> Void in
            
            
            // reload data ...
            
            self.reloadPosts({ () -> Void in
                pullToRefreshView.stopAnimating()
            })
        })
        
        timelineTableView.pullToRefreshView.preserveContentInset = true
        timelineTableView.pullToRefreshView.setProgressView(progressView)
        
        
        
        self.timelineTableView.backgroundColor = UIColor.clearColor()
       // self.timelineTableView.rowHeight = UITableViewAutomaticDimension
        self.timelineTableView.estimatedRowHeight = 100
//        self.timelineTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.timelineTableView.contentInset.bottom = 100

        
        // set title font
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "OpenSans", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // add post button
        let postBtn = UIButton(frame: CGRectMake(self.view.frame.width/2-25,self.view.frame.height-75,50,50))
        let postBtnImage = UIImage(named: "Button_Create@2x.png")
        postBtn.setBackgroundImage(postBtnImage, forState: UIControlState.Normal)
        postBtn.addTarget(self, action: "postClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(postBtn)
        self.view.bringSubviewToFront(postBtn)
        
        self.reloadPosts(nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // make the navigation bar transparent 
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        

        super.viewWillAppear(animated)
        
        
        if self.maskLayer == nil {
            self.maskLayer = CAGradientLayer()
            self.maskLayer?.colors = [UIColor.whiteColor().CGColor, UIColor.clearColor().CGColor]
            self.maskLayer?.locations = [0.63, 0.78]
            self.maskLayer?.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
            println(self.timelineTableView.bounds.size.width)
            println(self.maskLayer?.bounds)
            println(self.view.bounds)
            self.maskLayer?.anchorPoint = CGPointZero
            self.tableMaskView.layer.mask = self.maskLayer
        }
        
//        self.reloadPosts(nil)
        
//        // initial load
//        self.reloadPosts { () -> Void in
//            let num = self.posts.count
//            var idxPaths: [NSIndexPath] = []
//            
//            for i in 1...4 {
//                idxPaths.append(NSIndexPath(forRow: i-1, inSection: 0))
//            }
////            self.timelineTableView.reloadRowsAtIndexPaths(idxPaths, withRowAnimation: UITableViewRowAnimation.None)
//        }
    }
    
    func reloadPosts(afterLoad: (() -> Void)?) {
        println("reloading")
        self.college.getPosts({ (posts, err) -> Void in
            if err == nil && posts.count > 0 {
                self.posts = []
    
                var lastDateStr = ""
                
                for post in posts {
                    let dateStr = post.getDateStr()
                    
                    if dateStr != lastDateStr {
                        let placeholder = Post()
                        placeholder.life = -99
                        placeholder.content = dateStr
                        self.posts.append(placeholder)
                        lastDateStr = dateStr
                    }
                    self.posts.append(post)
                }
                
                self.timelineTableView.reloadData()
            }
            
            if let f = afterLoad {
                f()
            }
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = self.posts[indexPath.row]

        // content cell
        if post.life != -99 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as TimelineTableViewCell
            cell.setValues(post)
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }
        // time cell
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeCell") as TimeTableViewCell
            cell.bgView.layer.cornerRadius = 15.0
            cell.bgView.layer.frame = CGRectInset(cell.bgView.frame, 20, 20)
            cell.timeLabel.text = post.content
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }
        
        
//        // temporary use
//        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as TimelineTableViewCell
//        cell.contentLabel.text = "\(post.content)[\(post.likes)]"
//        cell.backgroundColor = UIColor.clearColor()
//        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "show_post_detail") {
            let pdvc = segue.destinationViewController as PostDetailViewController
            let idxPath = self.timelineTableView.indexPathForSelectedRow()
            pdvc.post = self.posts[idxPath!.row]
        }
    }
    
    func postClicked() {
        let postViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("post_view_controller") as PostViewController
        
        self.presentViewController(postViewController, animated: true, completion: nil)
    }
    
    @IBAction func upvote(sender: AnyObject) {
        let btn = sender as UIButton
        let cell = btn.superview?.superview as UITableViewCell
        let indexPath = self.timelineTableView.indexPathForCell(cell)
        let post = self.posts[indexPath!.row]
        post.incrementKey("likes")
        post.incrementKey("life", byAmount: User.currentUser().voteWeight)
        post.saveInBackgroundWithBlock { (success, err) -> Void in
            if success {
                self.reloadPosts(nil)
            }
        }
    }
    
    @IBAction func downvote(sender: AnyObject) {
        let btn = sender as UIButton
        let cell = btn.superview?.superview as UITableViewCell
        let indexPath = self.timelineTableView.indexPathForCell(cell)
        let post = self.posts[indexPath!.row]
        post.incrementKey("likes", byAmount: -1)
        post.incrementKey("life", byAmount: 0 - User.currentUser().voteWeight)
        post.saveInBackgroundWithBlock { (success, err) -> Void in
            if success {
                self.reloadPosts(nil)
            }
        }
    }
    
    @IBAction func profileClicked(sender: AnyObject) {
        let postViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("profile_view_controller") as ProfileViewController
        self.presentViewController(postViewController, animated: true, completion: nil)
    }
}

