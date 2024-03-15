//
//  Tactile_TotalsApp.swift
//  Tactile Totals
//
//  Created by Steven M. Caruso on 1/28/24.
//

import SwiftUI
import RealityKitContent

@main
@MainActor
struct Tactile_TotalsApp: App {
	
    @State private var keypad = Keypad()
    @MainActor init() {
        RealityKitContent.NumberValueComponent.registerComponent()
        RealityKitContent.KeyOperationComponent.registerComponent()
    }
	
    var body: some Scene {
        WindowGroup {
			ContentView()
                .environmentObject(keypad.helpers)
				.environmentObject(keypad)
        }
		.windowStyle(.volumetric)
        .defaultSize(keypad.helpers.defaultWindowSize)
//        .defaultSize(width: 9.25, height: 0.25, depth: 11.25, in: .centimeters)
//        .windowResizability(.contentSize)
    }
}

// 25cm -> 340pts
// 50cm -> 680pts
// 100cm -> 1360pts
// 1cm = 13.6pts?
