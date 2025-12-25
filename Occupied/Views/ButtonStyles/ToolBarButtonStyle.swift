//
//  ToolBarButtonStyle.swift
//  Occupied
//
//  Created by Morgan Harris on 12/16/25.
//

import SwiftUI

struct ToolBarButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		ZStack {
			configuration.label
				.padding(10)
				.background(.greenGray)
				.clipShape(Circle())
				.overlay(
					Circle()
						.stroke(.deepGray, lineWidth: 1)
				)
		}
		.font(.system(size: 26))
		.italic(true)
		.fontWeight(.light)
		.foregroundStyle(.deepGray)
	}
}
