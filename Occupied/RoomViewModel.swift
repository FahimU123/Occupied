//
//  RoomViewModel.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import FirebaseFirestore
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
    
    func createARoom(name: String, joinCode: String, isOccupied: Bool) {
        let newRoom = Room(name: name, joinCode: joinCode, isOccupied: isOccupied)
        
        do {
            _ = try db.collection("Room").addDocument(from: newRoom)
        } catch {
            AppLogger.logger.error("Error creating a new room \(error.localizedDescription)")
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
    
    func fetchRooms() {
        db.collection("Rooms").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                AppLogger.logger.info("No documents")
                return
            }
            
            self.rooms = documents.map { queryDocumentSnapshot -> Room in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["author"] as? String ?? "No Room Found"
                let joinCode = data["pages"] as? String ?? "No Code Found"
                let isOccupied = data["pages"] as? Bool ?? false
                
                return Room(id: id, name: name, joinCode: joinCode, isOccupied: isOccupied)
            }
        }
    }

}
