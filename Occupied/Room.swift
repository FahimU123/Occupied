//
//  Room.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import FirebaseFirestore
import Foundation

struct Room: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let joinCode: String
    var isOccupied: Bool
}
