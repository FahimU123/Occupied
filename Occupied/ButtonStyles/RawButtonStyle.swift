//
//  RawButtonStyle.swift
//  Occupied
//
//  Created by Morgan Harris on 12/16/25.
//
// This gets rid of the button press effect entirely.
// It also serves as a template to build button styles off of

import SwiftUI

struct RawButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.opacity(1)
			.scaleEffect(1)
	}
}
