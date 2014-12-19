import Foundation

class Reply : PFObject, PFSubclassing {
    
    @NSManaged var user: User
    @NSManaged var post: Post
    @NSManaged var content: String
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func initWith(post: Post, content: String) -> Reply {
        let reply = Reply()
        reply.user = User.currentUser()
        reply.post = post
        reply.content = content
        return reply
    }
    
    
    
    class func parseClassName() -> String! {
        return "Reply"
    }
}