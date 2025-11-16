//
//  RoomViewModel.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation
import os

@Observable
class RoomViewModel {
    
    private var db = Firestore.firestore()
    
    var rooms: [Room]
    
    init(db: Firestore = Firestore.firestore(), rooms: [Room]) {
        self.db = db
        self.rooms = rooms
    }
    
    func createARoom(name: String, joinCode: String, isOccupied: Bool, ownerID: String) {
        let newRoom = Room(name: name, joinCode: joinCode, isOccupied: isOccupied, ownerID: ownerID)
        
        do {
            _ = try db.collection("Room").addDocument(from: newRoom)
        } catch {
            AppLogger.logger.error("Error creating a new room \(error.localizedDescription)")
        }
    }
    
    func fetchRooms() {
        db.collection("Room")
            .whereField("ownerID", isEqualTo: Auth.auth().currentUser?.uid ?? "fetching room did not work")
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                AppLogger.logger.info("No documents")
                return
            }
            
            self.rooms = documents.map { queryDocumentSnapshot -> Room in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? "No Room Found"
                let joinCode = data["joinCode"] as? String ?? "No Code Found"
                let isOccupied = data["isOccupied"] as? Bool ?? false
                let ownerID = data["ownerID"] as? String ?? "No owner for room found"
            
                self.rooms.append(Room(name: name, joinCode: joinCode, isOccupied: isOccupied))
                return Room(id: id, name: name, joinCode: joinCode, isOccupied: isOccupied, ownerID: ownerID)
            }
        }
    }
    
    func joinARoom() {
        
    }
    
    func checkIntoRoom() {
        
    }
    
    func checkOutOfRom() {
        
    }
    
    func deleteARoom(room: Room) {
        guard let roomID = room.id else { return }
        
        db.collection("Room").document(roomID).delete() { error in
            if let error = error {
                AppLogger.logger.error("Error deleting room \(error.localizedDescription)")
            }
        }
    }
}
