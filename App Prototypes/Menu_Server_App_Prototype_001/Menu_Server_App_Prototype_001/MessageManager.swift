
import Foundation
import Firebase

class MessageManager {
    //This class handles ticket statuses that the app UI can use to display and update
    //order information for each table.
    
    static let ref = FIRDatabase.database().reference().child("Messages")
    
    //this is ok as async
    static func CreateTicketAsync(id: String){
        ref.child(id).child("user").setValue("nil")
        ref.child(id).child("server").setValue("nil")
    }
    
    // the messageRef should really be FIRDatabase.databae().reference().child("Messages").child(ticket.message_ID)
    //but this would have to be updated everytime a new ticket is attached to the user.
    
    //if that ends up being too hard you can just do it this way
    //FIRDatabase.databae().reference().child("Messages")
    
    //    refHandle = messageRef.observe(FIRDataEventType.value, with: { (snapshot) in
    //    let postDict = snapshot.value as! [String : AnyObject]
    //
    //    only one string at a time is ever in the db and it's the latest one sent
    //    you can choose to add those strings to an array on the controller if you want to keep track of them
    //    ping the UInotification here
    
    //    })
}
