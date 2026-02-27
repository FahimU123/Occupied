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

@MainActor
@Observable
class RoomViewModel {
    
    var db = Firestore.firestore()
    var rooms: [Room] = []
    var showJoinCodeError: Bool = false
    
    init(rooms: [Room] = []) {
        self.rooms = rooms
    }
    
    func createARoom(name: String, joinCode: String, isOccupied: Bool, ownerID: String, members: [String]) async {
        let newRoom = Room(name: name, joinCode: joinCode, isOccupied: isOccupied, ownerID: ownerID, members: members)
        
        do {
            _ = try db.collection("Room").addDocument(from: newRoom)
        } catch {
            print("Error creating a new room \(error.localizedDescription)")
        }
    }
    
    func fetchRooms() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("Room")
            .whereField("members", arrayContains: uid)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                
                guard let self = self else { return }
                
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
    
    func joinARoom(joinCode: String) async -> Bool {
        guard let userID = Auth.auth().currentUser?.uid else { return false }
        
        do {
            let snapshot = try await db.collection("Room")
                .whereField("joinCode", isEqualTo: joinCode)
                .getDocuments()
            
            guard let document = snapshot.documents.first else {
                showJoinCodeError = true
                return false
            }
            
            try await document.reference.updateData([
                "members": FieldValue.arrayUnion([userID])
            ])
            return true
        } catch {
            print("Error joining room: \(error)")
            return false
        }
    }
    
    func updateRoomOccupancy(for room: Room?, isOccupied: Bool) async {
        guard let roomID = room?.id else { return }
        let roomRef = db.collection("Room").document(roomID)
        
        do {
            try await roomRef.updateData(["isOccupied": isOccupied])
            
        } catch {
            print("Error updating occupancy: \(error.localizedDescription)")
        }
    }
    
    func leaveRoom(room: Room?) async {
        guard let roomID = room?.id, let userID = Auth.auth().currentUser?.uid else { return }
        let roomRef = db.collection("Room").document(roomID)
        
        do {
            try await roomRef.updateData(["members": FieldValue.arrayRemove([userID])])
        } catch {
            print("Error leaving room: \(error.localizedDescription)")
        }
    }
    
    func deleteARoom(room: Room) async {
        guard let roomID = room.id, let ownerID = room.ownerID else { return }
        let currentUserID = Auth.auth().currentUser?.uid
        
        if ownerID == currentUserID {
            do {
                try await db.collection("Room").document(roomID).delete()
            } catch {
                print("Error deleting room \(error.localizedDescription)")
            }
        }
    }
}
