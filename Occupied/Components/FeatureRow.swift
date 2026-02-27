//
//  FeatureRow.swift
//  Occupied
//
//  Created by Fahim Uddin on 1/6/26.
//

import SwiftUI

struct FeatureRow: View {
    let text: String
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.gold)
            Text(text)
                .foregroundStyle(.white)
        }
    }
}
