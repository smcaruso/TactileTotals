import RealityKit

// Ensure you register this component in your app’s delegate using:
// KeyOperationComponent.registerComponent()

public struct KeyOperationComponent: Component, Codable {
	public let operation: keyOperation
    public init(_ initValue: keyOperation) { operation = initValue }
}

public enum keyOperation: String, Codable {
	case add = "+"
	case subtract = "-"
	case multiply = "*"
	case divide = "/"
	case clear = "c"
	case equal = "="
	case decimal = "."
}
