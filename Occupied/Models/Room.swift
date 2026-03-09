//
//  Room.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import FirebaseFirestore
import Foundation

struct Room: Codable, Equatable, Identifiable {
    @DocumentID var id: String?
    var name: String?
    var joinCode: String?
    var isOccupied: Bool?
    var ownerID: String?
    var members: [String]?
    var releaseAt: Date?
    var occupiedByUID: String?
}
