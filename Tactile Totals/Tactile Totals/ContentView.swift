//
//  ContentView.swift
//  Tactile Totals
//
//  Created by Steven M. Caruso on 1/28/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
	
    @State private var buffer: Double?
    @State private var display: String = "0000000000"
    
    @State private var currentOperation: keyOperation?
	
	@GestureState private var isDetectingTapGesture: Bool = false

	@EnvironmentObject var helpers: SMCHelpers
	@EnvironmentObject var keypad: Keypad
	
	var body: some View {
		GeometryReader3D { geometry in
			VStack {
				Spacer()
                Text( display )
                    .font(.custom("Big", size: 35))
                    .fontDesign(.monospaced)
                    .padding(EdgeInsets(top: 25, leading: 65, bottom: 25, trailing: 65))
                    .glassBackgroundEffect()
                RealityView {content in
					let keypadModel: Entity = await keypad.buildKeypad()
                    content.add(keypadModel)
					
					keypadModel.children.forEach { entity in
						
						let initialTransform: Transform = entity.transform
						let subscription = content.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: entity) { event in
							entity.move(to: initialTransform, relativeTo: keypadModel, duration: 0.1, timingFunction: .easeOut)
							// todo: unsubscribe
						}
					}

                }
                .gesture(
                    SpatialTapGesture()
                        .targetedToAnyEntity()
                        .onEnded({ gestureEvent in
							
							let pressedTransform: Transform = .init(translation: SIMD3(0.0, 0.0, -0.0025))
							let downAnimation: AnimationPlaybackController = gestureEvent.entity.move(
								to: pressedTransform,
								relativeTo: gestureEvent.entity,
								duration: 0.2,
								timingFunction: .easeOut
							)
							
							if let keyNumber: NumberValueComponent = gestureEvent.entity.components[NumberValueComponent.self] {
                                tapKey(keyNumber.keyValue)
                            }
                            
                            if let keyFunc: KeyOperationComponent = gestureEvent.entity.components[KeyOperationComponent.self] {
                                tapKey(keyFunc.operation)
                            }
                            
                            
                        })
                )

			}
		}
	}
    
    private func tapKey(_ numberValue: Int) {
        
        return
        
    }
    
    private func tapKey(_ operation: keyOperation) {
        switch operation {
        case .add, .subtract, .multiply, .divide:
            break
        case .decimal:
            break
        case .equal:
            break
        case .clear:
            break
        }
    }
    
    private func doMath(first: Double, second: Double, operation: keyOperation) -> Double {
        
        var resultValue: Double?
        
        switch operation {
        case .add:
            resultValue = first + second
            break
        case .subtract:
            resultValue = first - second
            break
        case .multiply:
            resultValue = first * second
            break
        case .divide:
            resultValue = first / second
            break
        default:
            break
        }
        
        
        if let validateResult = resultValue {
            return resultValue!
        }
        
        else { return 0.0 } // NaN
        
    }
	
	
}

#Preview(windowStyle: .volumetric) {
	ContentView()
}
