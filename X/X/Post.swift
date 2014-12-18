import Foundation

class Post : PFObject, PFSubclassing {
    
    @NSManaged var content: String
    @NSManaged var life: Int
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func initWithContent(content: String) -> Post {
        let post = Post()
        post.life = 24
        post.content = content
        return post
    }
    
    class func parseClassName() -> String! {
        return "Post"
    }
}