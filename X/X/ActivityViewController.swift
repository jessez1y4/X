//
//  ActivityViewController.swift
//  X
//
//  Created by yue zheng on 12/18/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class ActivityViewController: BackgroundViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var user = User.currentUser()
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        //        self.tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.tableView.contentInset.bottom = 100
        
        // Do any additional setup after loading the view.
        
        self.reloadPosts(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadPosts(afterLoad: (() -> Void)?) {
        
        self.user.getPosts({ (posts, err) -> Void in
            self.posts = posts
            self.tableView.reloadData()
            
            if let f = afterLoad {
                f()
            }
        })
        
    }

    
    func tableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as ActivityTableViewCell
        let post = self.posts[indexPath.row]
        
        cell.setValues(post)
        cell.numberView.layer.cornerRadius = 10.0
        cell.numberView.layer.frame = CGRectInset(cell.numberView.frame, 20, 20)
        
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
    
    
    @IBAction func backClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
