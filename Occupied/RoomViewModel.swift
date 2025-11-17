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
    
    func createARoom(name: String, joinCode: String, isOccupied: Bool, ownerID: String, members: [String]) {
        let newRoom = Room(name: name, joinCode: joinCode, isOccupied: isOccupied, ownerID: ownerID, members: members)
        
        do {
            _ = try db.collection("Room").addDocument(from: newRoom)
        } catch {
            AppLogger.logger.error("Error creating a new room \(error.localizedDescription)")
        }
    }
    
    
    func fetchRooms() {
        db.collection("Room")
            .whereField("members", arrayContains: Auth.auth().currentUser?.uid ?? "could not fetch rooms")
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
                let members = data["members"] as? [String] ?? []
            
                return Room(id: id, name: name, joinCode: joinCode, isOccupied: isOccupied, ownerID: ownerID, members: members)
            }
        }
    }
    
    func joinARoom(joinCode: String) {
        print("tryna join a room")
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("Room")
            .whereField("joinCode", isEqualTo: joinCode)
            .getDocuments { (snapshot, error) in
                guard let document = snapshot?.documents.first else {
                    return
                }
                document.reference.updateData([
                    "members": FieldValue.arrayUnion([userID])
                ])
            }
    }
    
    func updateRoomOccupancy(for room: Room?, isOccupied: Bool) async {
        guard let roomID = room?.id else {
            AppLogger.logger.error("Error: Room is missing a document ID.")
            return
        }
        let roomRef = db.collection("Room").document(roomID)
        
        do {
            try await roomRef.updateData(["isOccupied": isOccupied])
        } catch {
            AppLogger.logger.error("Error updating room occupancy: \(error.localizedDescription)")
        }
    }
    
    // remove yourself from the members array but if you are owner then what
    func leaveRoom(room: Room) {
        
    }
    
    // removes a UID from the members array
    func kickOutOfRoom(room: Room) {
        
    }
    
    // FIXME: allow only if owner
    func deleteARoom(room: Room) {
        guard let roomID = room.id else { return }
        
        db.collection("Room").document(roomID).delete() { error in
            if let error = error {
                AppLogger.logger.error("Error deleting room \(error.localizedDescription)")
            }
        }
    }
}
