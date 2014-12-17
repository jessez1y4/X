import Foundation

class College : PFObject, PFSubclassing {
    
    @NSManaged var name: String
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "College"
    }
    
    func getPosts() {
        
    }
}