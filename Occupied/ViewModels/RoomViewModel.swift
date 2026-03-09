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
    private var autoVacateTimer: Timer? = nil
    
    var db = Firestore.firestore()
    var rooms: [Room] = []
    var showJoinCodeError: Bool = false
    
    init(rooms: [Room] = []) {
        self.rooms = rooms
        startAutoVacateMonitor()
    }
    
    func createARoom(name: String, joinCode: String, isOccupied: Bool, ownerID: String, members: [String]) async {
        let newRoom = Room(name: name, joinCode: joinCode, isOccupied: isOccupied, ownerID: ownerID, members: members)
        do {
            _ = try db.collection("Room").addDocument(from: newRoom)
        } catch {
            AppLogger.logger.error("Error creating room: \(error.localizedDescription)")
        }
    }
    
    func fetchRooms() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("Room")
            .whereField("members", arrayContains: uid)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self else { return }
                guard let documents = querySnapshot?.documents else { return }
                
                self.rooms = documents.map { doc -> Room in
                    let data = doc.data()
                    return Room(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "No Room Found",
                        joinCode: data["joinCode"] as? String ?? "No Code Found",
                        isOccupied: data["isOccupied"] as? Bool ?? false,
                        ownerID: data["ownerID"] as? String ?? "",
                        members: data["members"] as? [String] ?? [],
                        releaseAt: (data["releaseAt"] as? Timestamp)?.dateValue(),
                        occupiedByUID: data["occupiedByUID"] as? String
                    )
                }
            }
    }
    
    func joinARoom(joinCode: String) async -> String? {
        guard let userID = Auth.auth().currentUser?.uid else { return nil }
        
        do {
            let snapshot = try await db.collection("Room")
                .whereField("joinCode", isEqualTo: joinCode)
                .getDocuments()
            
            guard let document = snapshot.documents.first else { return nil }
            let roomID = document.documentID
            
            try await db.collection("Room").document(roomID).updateData([
                "members": FieldValue.arrayUnion([userID])
            ])
            
            return roomID
        } catch {
            AppLogger.logger.error("Error joining room: \(error.localizedDescription)")
            return nil
        }
    }
    
    func updateRoomOccupancy(for room: Room?, isOccupied: Bool, releaseAt: Date? = nil) async {
        guard let roomID = room?.id else { return }
        
        var data: [String: Any] = ["isOccupied": isOccupied]
        
        if isOccupied {
            data["occupiedByUID"] = Auth.auth().currentUser?.uid ?? ""
            if let releaseAt {
                data["releaseAt"] = Timestamp(date: releaseAt)
            }
        } else {
            data["occupiedByUID"] = FieldValue.delete()
            data["releaseAt"] = FieldValue.delete()
        }
        
        do {
            try await db.collection("Room").document(roomID).updateData(data)
        } catch {
            AppLogger.logger.error("Error updating occupancy: \(error.localizedDescription)")
        }
    }
    
    func extendTime(for room: Room, newReleaseAt: Date) async {
        guard let roomID = room.id else { return }
        do {
            try await db.collection("Room").document(roomID).updateData([
                "releaseAt": Timestamp(date: newReleaseAt)
            ])
        } catch {
            AppLogger.logger.error("Error extending time: \(error.localizedDescription)")
        }
    }
    
    func leaveRoom(room: Room?) async {
        guard let roomID = room?.id, let userID = Auth.auth().currentUser?.uid else { return }
        do {
            try await db.collection("Room").document(roomID).updateData([
                "members": FieldValue.arrayRemove([userID])
            ])
        } catch {
            AppLogger.logger.error("Error leaving room: \(error.localizedDescription)")
        }
    }
    
    func deleteARoom(room: Room) async {
        guard let roomID = room.id else {
            AppLogger.logger.error("Delete failed: room has no ID")
            return
        }
        guard room.ownerID == Auth.auth().currentUser?.uid else {
            AppLogger.logger.error("Delete failed: not the owner")
            return
        }
        do {
            try await db.collection("Room").document(roomID).delete()
        } catch {
            AppLogger.logger.error("Error deleting room: \(error.localizedDescription)")
        }
    }
    
    deinit {
        autoVacateTimer?.invalidate()
    }
    
    func startAutoVacateMonitor() {
        autoVacateTimer?.invalidate()
        autoVacateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            let now = Date()
            let expiredRooms = self.rooms.filter { ( ($0.isOccupied ?? false) && (($0.releaseAt?.timeIntervalSince(now) ?? 0) <= 0) ) }
            for room in expiredRooms {
                Task {
                    await self.updateRoomOccupancy(for: room, isOccupied: false)
                }
            }
        }
    }
}
