//
//  KeypadWindowModel.swift
//  Tactile Totals
//
//  Created by Steven M. Caruso on 1/28/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct KeypadWindowModel: View {
	
	@EnvironmentObject var helpers: SMCHelpers
	@EnvironmentObject var keypad: Keypad
	
    @State private var rotationOffset = 15.0;
	@State private var windowScaleRootEntity = Entity()
		
    var body: some View {
		GeometryReader3D { geometry in
			RealityView { realityContent in
				
				// handles issue where mesh objects can be clipped by the size of the containing volumetric window:
				
				scaleToWindowSettings(entity: windowScaleRootEntity, with: realityContent,
									  for: geometry, defaultSize: helpers.defaultWindowSize)
				
                await realityContent.add(keypad.buildKeypad())
			} update: { realityContent in
				scaleToWindowSettings(entity: windowScaleRootEntity, with: realityContent,
									  for: geometry, defaultSize: helpers.defaultWindowSize)
			}
		}
		.frame(width: 380, height: 320, alignment: .bottom)
		.gesture(
            SpatialTapGesture().targetedToAnyEntity()
                .onEnded({ value in
                    print("that's \(value.entity.name)")
                })
        )
    }
	
	// Scaling function from https://www.lunarskydiving.com/blog/volume-window-zoom/
	
	func scaleToWindowSettings(entity: Entity, with content: RealityViewContent,
							   for proxy: GeometryProxy3D, defaultSize: Size3D) {
		
		// The size of the volume, scaled to reflect the selected Window Zoom.
		let scaledVolumeSize = content.convert(
		proxy.frame(in: .local), from: .local, to: .scene)

		// The user's selected Window Zoom scale factor, as
		// a ratio between the displayed size of the volume and
		// the default size of the volume's window group.
		let scale = ( scaledVolumeSize.extents / SIMD3<Float>(defaultSize) ).min()

		entity.scale = .one * scale
	}
}

#Preview(windowStyle: .volumetric) {
    KeypadWindowModel()
}
