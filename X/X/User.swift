import Foundation

class User : PFUser {
    
    @NSManaged var verified: Bool
    @NSManaged var college: College
    
    override class func load() {
        self.registerSubclass()
    }
    
    override class func currentUser() -> User! {
        return super.currentUser() as User!
    }
}