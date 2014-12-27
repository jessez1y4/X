//
//  ViewController.swift
//  X
//
//  Created by Yu Jiang on 12/14/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class TimelineViewController: BackgroundViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var tableView: UITableView!
    
    var college = User.currentUser().college
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var logoImage = UIImage(named: "bicon.png")
        var backCircleImage = UIImage(named: "light_circle.png")
        var frontCircleImage = UIImage(named: "dark_circle.png")
        var progressView = BMYCircularProgressView(frame: CGRectMake(0, 0, 25, 25), logo: logoImage, backCircleImage: backCircleImage, frontCircleImage: frontCircleImage)
        
        self.tableView.setPullToRefreshWithHeight(10, actionHandler: { (pullToRefreshView: BMYPullToRefreshView!) -> Void in
            
            
            // reload data ...
            
            self.reloadPosts({ () -> Void in
                pullToRefreshView.stopAnimating()
            })
        })
        
        tableView.pullToRefreshView.preserveContentInset = true
        tableView.pullToRefreshView.setProgressView(progressView)
        
        
        
        self.tableView.backgroundColor = UIColor.clearColor()
        // initial load
        self.reloadPosts(nil)
        
        // set title font
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "OpenSans", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // make the navigation bar transparent 
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
    
    func reloadPosts(afterLoad: (() -> Void)?) {
        self.college.getPosts({ (posts, err) -> Void in
            if err == nil {
                self.posts = []
                
                let calendar = NSCalendar.currentCalendar()
                let now = calendar.ordinalityOfUnit(NSCalendarUnit.DayCalendarUnit, inUnit: NSCalendarUnit.EraCalendarUnit, forDate: NSDate())
                
                for post in posts {
                    let from = calendar.ordinalityOfUnit(NSCalendarUnit.DayCalendarUnit, inUnit: NSCalendarUnit.EraCalendarUnit, forDate: post.createdAt)
                    let diff = now - from
                    
                    switch diff {
                    case 0:
                        
                    }
                }
                
                self.tableView.reloadData()
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

//        // content cell
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as TimelineTableViewCell
//            cell.contentLabel.text = "\(post.content)[\(post.likes)]"
//            cell.backgroundColor = UIColor.clearColor()
//            return cell
//        }
//        // time cell
//        else {
//            let cell = tableView.dequeueReusableCellWithIdentifier("TimeCell") as TimeTableViewCell
//            cell.textLabel!.text = "\(post.content)[\(post.likes)]"
//            cell.backgroundColor = UIColor.clearColor()
//            return cell
//        }
        
        
        // temporary use
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as TimelineTableViewCell
        cell.contentLabel.text = "\(post.content)[\(post.likes)]"
        cell.backgroundColor = UIColor.clearColor()
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "show_post_detail") {
            let pdvc = segue.destinationViewController as PostDetailViewController
            let idxPath = self.tableView.indexPathForSelectedRow()
            pdvc.post = self.posts[idxPath!.row]
        }
    }
    
    @IBAction func postClicked(sender: AnyObject) {
        let postViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("post_view_controller") as PostViewController
        
        self.presentViewController(postViewController, animated: true, completion: nil)
    }
    
    @IBAction func upvote(sender: AnyObject) {
        let btn = sender as UIButton
        let cell = btn.superview?.superview as UITableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)
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
        let indexPath = self.tableView.indexPathForCell(cell)
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
    }
}

