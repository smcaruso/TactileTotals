//
//  MakeRotation.swift
//  Tactile Totals
//
//  Created by Steven M. Caruso on 1/28/24.
//

import Foundation
import Spatial
import RealityKit

class SMCHelpers: ObservableObject {
	
	public let defaultWindowSize = Size3D(width: 380, height: 320, depth: 460)
		
	func makeRotation(x: Double, y: Double, z: Double) -> simd_quatf {
		
		let xInRadians: Float = Float(x) * (.pi / 180)
		let yInRadians: Float = Float(y) * (.pi / 180)
		let zInRadians: Float = Float(z) * (.pi / 180)
		
		let quaternionFromEuler: simd_quatf =
			simd_quatf(angle: xInRadians, axis: SIMD3<Float>(1, 0, 0)) *
			simd_quatf(angle: yInRadians, axis: SIMD3<Float>(0, 1, 0)) *
			simd_quatf(angle: zInRadians, axis: SIMD3<Float>(0, 0, 1))
		
		return quaternionFromEuler
	}
	
	func uniformScale(_ factor: Double) -> SIMD3<Float> {
		
		return SIMD3(Float(factor), Float(factor), Float(factor))
		
	}
	
}
