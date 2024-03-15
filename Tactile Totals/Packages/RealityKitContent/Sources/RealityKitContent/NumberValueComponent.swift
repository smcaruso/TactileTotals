import RealityKit

// Ensure you register this component in your app’s delegate using:
// NumberValueComponent.registerComponent()

public struct NumberValueComponent: Component, Codable {
    public var keyValue: Int = 0
    public init(_ value: Int) { keyValue = value }
}
