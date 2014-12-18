import Foundation

class Post : PFObject, PFSubclassing {
    
    @NSManaged var college: College
    @NSManaged var user: User
    @NSManaged var content: String
    @NSManaged var life: Int
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func initWithContent(content: String) -> Post {
        let post = Post()
        post.user = User.currentUser()
        post.college = User.currentUser().college
        post.life = 24
        post.content = content
        return post
    }
    
    
    
    class func parseClassName() -> String! {
        return "Post"
    }
}