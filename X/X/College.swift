import Foundation

class College : PFObject, PFSubclassing {
    
    @NSManaged var name: String
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "College"
    }
    
    func getPosts(callback: ([Post]!, NSError!) -> Void) -> Void {
        let q = Post.query()
        
        q.whereKey("college", equalTo: self)
        q.orderByDescending("createdAt")
        
        q.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            callback(results as? [Post], error)
        }
    }
}