//
//  SignButtonStyle.swift
//  Occupied
//
//  Created by Morgan Harris on 12/16/25.
//


import SwiftUI

struct SignButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(width: 350, height: 70)
			.background(.greenGray)
			.clipShape(.rect(cornerRadius: 20))
			.overlay(
				RoundedRectangle(cornerRadius: 20)
					.stroke(.deepGray, lineWidth: 1)
			)
		
			.font(.system(size: 36))
			.italic(true)
			.fontWeight(.light)
			.foregroundStyle(.deepGray)
	}
}
