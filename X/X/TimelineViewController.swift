//
//  ViewController.swift
//  X
//
//  Created by Yu Jiang on 12/14/14.
//  Copyright (c) 2014 PPC. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var logoImage = UIImage(named: "bicon.png")
        var backCircleImage = UIImage(named: "light_circle.png")
        var frontCircleImage = UIImage(named: "dark_circle.png")
        var progressView = BMYCircularProgressView(frame: CGRectMake(0, 0, 25, 25), logo: logoImage, backCircleImage: backCircleImage, frontCircleImage: frontCircleImage)
        
        self.tableView.setPullToRefreshWithHeight(10, actionHandler: { (pullToRefreshView: BMYPullToRefreshView!) -> Void in
            
            
        // reload data ...
            sleep(3)
            self.tableView.reloadData()
            pullToRefreshView.stopAnimating()
//            self.page = self.circle.getItems(0, per: self.per, callback: { (items, error) -> Void in
//                if error == nil && items.first?.objectId != self.items.first?.objectId {
//                    self.items = items
//                    self.collectionView.reloadData()
//                }
//                pullToRefreshView.stopAnimating()
//            })
        })
        
        tableView.pullToRefreshView.preserveContentInset = true
        tableView.pullToRefreshView.setProgressView(progressView)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as TimelineTableViewCell

        cell.textLabel.text = "test!:):)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }



}

