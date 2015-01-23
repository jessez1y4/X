import Foundation

class User : PFUser {
    
    @NSManaged var verified: Bool
    @NSManaged var college: College
    @NSManaged var domain: String
    @NSManaged var voteWeight: Int
    
    override class func load() {
        self.registerSubclass()
    }
    
    override class func currentUser() -> User! {
        return super.currentUser() as User!
    }
    
    func getPosts(callback: ([Post]!, NSError!) -> Void) {
        let q = Post.query()
        
        q.whereKey("user", equalTo: self)
        q.orderByDescending("createdAt")
        q.orderByDescending("unread")
        
        
        q.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            callback(results as? [Post], error)
        }
    }
    
    func getVotedPosts(relation: String, callback: ([Post]!, NSError!) -> Void) {
        let rel = self.relationForKey(relation)
        rel.query().findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            callback(results as? [Post], error)
        })
    }
    
    func addRelation(post: Post, relation: String) {
        let rel = self.relationForKey(relation)
        rel.addObject(post)
        self.saveEventually()
    }
}