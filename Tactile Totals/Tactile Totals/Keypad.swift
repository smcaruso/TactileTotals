//
//  Keypad.swift
//  Tactile Totals
//
//  Created by Steven M. Caruso on 2/25/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

@MainActor
class Keypad: ObservableObject {
    
    public let helpers: SMCHelpers = SMCHelpers()
        
    private let keypadRoot: Entity = Entity()

    private var bottomCase: ModelEntity?
    
    public var key0: ModelEntity?
    public var key1: ModelEntity?
    public var key2: ModelEntity?
    public var key3: ModelEntity?
    public var key4: ModelEntity?
    public var key5: ModelEntity?
    public var key6: ModelEntity?
    public var key7: ModelEntity?
    public var key8: ModelEntity?
    public var key9: ModelEntity?

    public var keyClear: ModelEntity?
    public var keyDec: ModelEntity?
    public var keyDiv: ModelEntity?
    public var keyEqual: ModelEntity?
    public var keyMinus: ModelEntity?
    public var keyMulti: ModelEntity?
    public var keyPlus: ModelEntity?
    
    // transforms for each key
    
    private let numericKeyPosition: [SIMD3<Float>] = [
        SIMD3<Float>(x: -0.042, y: 0.0025, z: -0.0206), // 0
        SIMD3<Float>(x: -0.021, y: 0.0025, z: -0.0315), // 1
        SIMD3<Float>(x: -0.021, y: 0.0025, z: -0.0105), // 2
        SIMD3<Float>(x: -0.021, y: 0.0025, z:  0.0105), // 3
        SIMD3<Float>(x:  0.000, y: 0.0025, z: -0.0315), // 4
        SIMD3<Float>(x:  0.000, y: 0.0025, z: -0.0105), // 5
        SIMD3<Float>(x:  0.000, y: 0.0025, z:  0.0105), // 6
        SIMD3<Float>(x:  0.021, y: 0.0025, z: -0.0315), // 7
        SIMD3<Float>(x:  0.021, y: 0.0025, z: -0.0105), // 8
        SIMD3<Float>(x:  0.021, y: 0.0025, z:  0.0105)  // 9
    ]
    
    private let keyClearPosition = SIMD3<Float>(x:  0.042, y: 0.0025, z: -0.0315)
    private let keyDecPosition   = SIMD3<Float>(x: -0.042, y: 0.0025, z:  0.0105)
    private let keyMultiPosition = SIMD3<Float>(x:  0.042, y: 0.0025, z: -0.0105)
    private let keyDivPosition   = SIMD3<Float>(x:  0.042, y: 0.0025, z:  0.0105)
    private let keyMinusPosition = SIMD3<Float>(x:  0.042, y: 0.0025, z:  0.0315)

    private let keyEqualPosition = SIMD3<Float>(x: -0.031083, y: 0.0025, z:  0.0315)
    private let keyPlusPosition  = SIMD3<Float>(x:  0.011, y: 0.0025, z:  0.0315)
	
//    init() {
//    }
    
    public func buildKeypad() async -> Entity {
        
        if let bottomCaseImport = try? await Entity(named: "TTBottomCase", in: realityKitContentBundle),
           let firstRoot = bottomCaseImport.children.first,
           let secondRoot = firstRoot.children.first,
           let modelEntity = secondRoot.children.first as? ModelEntity,
           let model = modelEntity.model {
            
            var bottomCaseMaterial = PhysicallyBasedMaterial()
            bottomCaseMaterial.baseColor = PhysicallyBasedMaterial.BaseColor(tint: UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1.0 ) )
            bottomCaseMaterial.roughness = 0.75
            
            bottomCase = ModelEntity(mesh: model.mesh, materials: [ bottomCaseMaterial ] )
            bottomCase?.transform.rotation = helpers.makeRotation(x: -90, y: 0, z: 0)
            bottomCase?.components.set( GroundingShadowComponent(castsShadow: true) )
            keypadRoot.addChild(bottomCase!)
            
        }
        
        var initKeys = [ModelEntity?](repeating: nil, count: 10)
        
        if let keyZeroImport = try? await Entity(named: "TTKeyZero", in: realityKitContentBundle),
           let firstRoot = keyZeroImport.children.first,
           let secondRoot = firstRoot.children.first,
           let modelEntity = secondRoot.children.first as? ModelEntity,
           let model = modelEntity.model {
                                    
            initKeys[0] = ModelEntity(
                mesh: model.mesh,
                materials: [ generateMaterial(for: .key0) ]
            )
            
            initKeys[0]?.name = "Key0"
            initKeys[0]?.setPosition(numericKeyPosition[0], relativeTo: nil)
            initKeys[0]?.components.set( setUpComponents(model.mesh.bounds.max, numberValue: 0) )
            initKeys[0]?.transform.rotation = helpers.makeRotation(x: -90, y: 0, z: 0)
            
            key0 = initKeys[0]
            keypadRoot.addChild(key0!)
            
        }
        
        if let keyStdImport = try? await Entity(named: "TTKeyStd", in: realityKitContentBundle),
           let firstRoot = keyStdImport.children.first,
           let secondRoot = firstRoot.children.first,
           let modelEntity = secondRoot.children.first as? ModelEntity,
           let model = modelEntity.model {
            
            let keyStdBounds: SIMD3<Float> = model.mesh.bounds.max
            let keyStdMesh: MeshResource = model.mesh
            
            // Numeric key setup:
            
            for i in 1...9 {
                
                let textureDict: [Int : ImageResource] = [
                    1: .key1,
                    2: .key2,
                    3: .key3,
                    4: .key4,
                    5: .key5,
                    6: .key6,
                    7: .key7,
                    8: .key8,
                    9: .key9
                ]
                
                initKeys[i] = ModelEntity(
                    mesh: keyStdMesh,
                    materials: [ generateMaterial(for: textureDict[i]!) ]
                )
                
                initKeys[i]?.name = "Key\(i)"
                initKeys[i]?.setPosition(numericKeyPosition[i], relativeTo: nil)
                initKeys[i]?.components.set( setUpComponents(keyStdBounds, numberValue: i) )
                initKeys[i]?.transform.rotation = helpers.makeRotation(x: -90, y: 0, z: 0)
                
            }
            
            key1 = initKeys[1]
            key2 = initKeys[2]
            key3 = initKeys[3]
            key4 = initKeys[4]
            key5 = initKeys[5]
            key6 = initKeys[6]
            key7 = initKeys[7]
            key8 = initKeys[8]
            key9 = initKeys[9]
            
            // Operation key setup:

            keyClear = ModelEntity(
                mesh: keyStdMesh,
                materials: [ generateMaterial(for: .keyClear) ]
            )
            keyClear?.name = "KeyClear"
            keyClear?.setPosition(keyClearPosition, relativeTo: nil)
            keyClear?.components.set( setUpComponents(keyStdBounds, operation: .clear) )
            keyClear?.transform.rotation = helpers.makeRotation(x: -90, y: 0, z: 0)

            
            keyDec = ModelEntity(
                mesh: keyStdMesh,
                materials: [ generateMaterial(for: .keyDecimal) ]
            )
            keyDec?.name = "KeyDec"
            keyDec?.setPosition(keyDecPosition, relativeTo: nil)
            keyDec?.components.set( setUpComponents(keyStdBounds, operation: .decimal) )
            keyDec?.transform.rotation = helpers.makeRotation(x: -90, y: 0, z: 0)
            
            keyDiv = ModelEntity(
                mesh: keyStdMesh,
                materials: [ generateMaterial(for: .keyDiv) ]
            )
            keyDiv?.name = "KeyDiv"
            keyDiv?.setPosition(keyDivPosition, relativeTo: nil)
            keyDiv?.components.set( setUpComponents(keyStdBounds, operation: .divide) )
            keyDiv?.transform.rotation = helpers.makeRotation(x: -90, y: 0, z: 0)

            
            keyMinus = ModelEntity(
                mesh: keyStdMesh,
                materials: [ generateMaterial(for: .keySub) ]
            )
            keyMinus?.name = "KeyMinus"
            keyMinus?.setPosition(keyMinusPosition, relativeTo: nil)
            keyMinus?.components.set( setUpComponents(keyStdBounds, operation: .subtract) )
            keyMinus?.transform.rotation = helpers.makeRotation(x: -90, y: 0, z: 0)
            
            keyMulti = ModelEntity(
                mesh: keyStdMesh,
                materials: [ generateMaterial(for: .keyMulti) ]
            )
            keyMulti?.name = "KeyMulti"
            keyMulti?.setPosition(keyMultiPosition, relativeTo: nil)
            keyMulti?.components.set( setUpComponents(keyStdBounds, operation: .multiply) )
            keyMulti?.transform.rotation = helpers.makeRotation(x: -90, y: 0, z: 0)
            
            // Root entity attachments:
            
            keypadRoot.addChild(key1!)
            keypadRoot.addChild(key2!)
            keypadRoot.addChild(key3!)
            keypadRoot.addChild(key4!)
            keypadRoot.addChild(key5!)
            keypadRoot.addChild(key6!)
            keypadRoot.addChild(key7!)
            keypadRoot.addChild(key8!)
            keypadRoot.addChild(key9!)
            
            keypadRoot.addChild(keyClear!)
            keypadRoot.addChild(keyDec!)
            keypadRoot.addChild(keyDiv!)
            keypadRoot.addChild(keyMinus!)
            keypadRoot.addChild(keyMulti!)
            
        }
        
        if let keyEqPlImport = try? await Entity(named: "TTKeyEqPl", in: realityKitContentBundle),
           let firstRoot = keyEqPlImport.children.first,
           let secondRoot = firstRoot.children.first,
           let modelEntity = secondRoot.children.first as? ModelEntity,
           let model = modelEntity.model {
            
            let longKeyBounds: SIMD3<Float> = model.mesh.bounds.max
            let longKeyMesh: MeshResource = model.mesh
            
            keyEqual = ModelEntity(
                mesh: longKeyMesh,
                materials: [ generateMaterial(for: .keyEqual) ]
            )
            keyEqual?.name = "KeyEqual"
            keyEqual?.setPosition(keyEqualPosition, relativeTo: nil)
            keyEqual?.components.set( setUpComponents(longKeyBounds, operation: .equal) )
            keyEqual?.transform.rotation = helpers.makeRotation(x: -90, y: 0, z: 90)
            
            keyPlus = ModelEntity(
                mesh: longKeyMesh,
                materials: [ generateMaterial(for: .keyAdd) ]
            )
            keyPlus?.name = "KeyPlus"
            keyPlus?.setPosition(keyPlusPosition, relativeTo: nil)
            keyPlus?.components.set( setUpComponents(longKeyBounds, operation: .add) )
            keyPlus?.transform.rotation = helpers.makeRotation(x: -90, y: 0, z: 90)
            
            keypadRoot.addChild(keyEqual!)
            keypadRoot.addChild(keyPlus!)
            
        }
        keypadRoot.transform.rotation = helpers.makeRotation(x: 0, y: 90, z: 0)
        keypadRoot.transform.scale = helpers.uniformScale(3.0)
        return keypadRoot
        
    }
    
    // WHY THE FUCK DOESN'T THIS WORK
    
    private func generateMaterial(for textureFilename: ImageResource) -> PhysicallyBasedMaterial {
        
        var newMaterial = PhysicallyBasedMaterial()
        newMaterial.roughness = 0.5
        
//        if let baseColorTexture = try? TextureResource.load(named: textureFilename) {
        
        let texture: CGImage = UIImage(resource: textureFilename).cgImage!
        if let baseColorTexture: TextureResource = try? .generate(from: texture, withName: UUID().uuidString, options: .init(semantic: .color)) {
            let baseColor = MaterialParameters.Texture(baseColorTexture)
            newMaterial.baseColor = PhysicallyBasedMaterial.BaseColor(texture: baseColor)
        } else {
            newMaterial.baseColor = PhysicallyBasedMaterial.BaseColor(tint: UIColor(red: 0.08, green: 0.8, blue: 0.08, alpha: 1.0 ) )
        }
        
        let normalTexture: CGImage = UIImage(resource: .plasticMoldDryBlast002NRM4K).cgImage!
        if let normalMapTexture: TextureResource = try? .generate(from: normalTexture, options: .init(semantic: .normal)) {
            let normalMap = MaterialParameters.Texture(normalMapTexture)
            newMaterial.normal = PhysicallyBasedMaterial.Normal(texture: normalMap)
        }
        
        return newMaterial
        
    }
    
    private func setUpComponents(_ bounds: SIMD3<Float>) -> [Component] {
        
        let collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: bounds)])
        let input = InputTargetComponent()
        let hover = HoverEffectComponent()
        
        return [collision, input, hover]
        
    }
    
    private func setUpComponents(_ bounds: SIMD3<Float>, numberValue: Int) -> [Component] {
        
        var components: [Component] = setUpComponents(bounds)
        
        let numberKeyValue: NumberValueComponent = .init(numberValue)
        components.append(numberKeyValue)
        
        return components
        
    }
    
    private func setUpComponents(_ bounds: SIMD3<Float>, operation: keyOperation) -> [Component] {
        
        var components: [Component] = setUpComponents(bounds)
        
        let keyOperation: KeyOperationComponent = .init(operation)
        components.append(keyOperation)
        
        return components
        
    }
	
}
