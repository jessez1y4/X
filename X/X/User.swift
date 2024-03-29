import Foundation

class User : PFUser {
    
    @NSManaged var verified: Bool
    @NSManaged var college: College
    @NSManaged var domain: String
    @NSManaged var voteWeight: Int
    @NSManaged var avatar: PFFile
    @NSManaged var longestLife: Int
    @NSManaged var shortestLife: Int
    @NSManaged var mostReplies: Int
    
    override class func load() {
        self.registerSubclass()
    }
    
    func setDefaultValues() {
        self.voteWeight = 1
        self.longestLife = 24
        self.shortestLife = 24
        self.mostReplies = 0
        self.verified = false
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
    
    func hasUnreadPosts(callback: (Bool) -> Void) {
        let q = Post.query()
        
        q.whereKey("user", equalTo: self)
        q.whereKey("unread", greaterThan: 0)
        
        q.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error != nil {
                return callback(false)
            }
            
            return callback(results.count > 0)
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