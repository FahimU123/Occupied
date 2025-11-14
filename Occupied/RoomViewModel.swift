//
//  RoomViewModel.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import FirebaseFirestore
import Foundation

@Observable
class RoomViewModel {
    
    private var db = Firestore.firestore()
    
    var rooms: [Room]
    
    func createARoom() {
        
    }
    
    func joinARoom() {
        
    }
    
    func checkIntoRoom() {
        
    }
    
    func checkOutOfRom() {
        
    }
    
    func fetchRooms() {
        db.collection("Rooms").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.rooms = documents.map { queryDocumentSnapshot -> Room in
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let author = data["author"] as? String ?? ""
                let numberOfPages = data["pages"] as? Int ?? 0
                
//                return Room(id: <#T##String?#>, name: <#T##String#>, joinCode: <#T##String#>, isOccupied: <#T##Bool#>)
            }
        }
    }
}
