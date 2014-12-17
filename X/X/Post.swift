import Foundation

class Post : PFObject, PFSubclassing {
    
    @NSManaged var content: String
    @NSManaged var life: Int
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Post"
    }
}