//
//  Size.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/22/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public struct Size: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    public static var zero: Size {
        Size(0, 0)
    }
    public static var unit: Size {
        Size(1, 1)
    }
    
    // MARK: - Indepenants
    public let id = UUID()
    public var width: Double
    public var height: Double
    
    
    // MARK: - Dependants
    public var point: Point { Point(width, height) }
    public var vector: Vector { Vector(width, height) }
    public var simd2: SIMD2<Float> { SIMD2<Float>(Float(width), Float(height)) }
    public var half: Size { self / 2 }
    public var min: Double { Swift.min(width, height) }
    public var max: Double { Swift.max(width, height) }
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    public init(_ width: Double, _ height: Double) {
        self.width = abs(width)
        self.height = abs(height)
    }
    public init(_ value: Double) {
        self.width = abs(value)
        self.height = abs(value)
    }
    public init(_ size: Size) {
        self.width = size.width
        self.height = size.height
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    public var description: String {
        "Size(width: \(width), height: \(height))"
    }
    // ----- Hashable ----- //
    public static func == (lhs: Size, rhs: Size) -> Bool {
        lhs.width == rhs.width && lhs.height == rhs.height
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case width
        case height
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.width = try container.decode(Double.self, forKey: .width)
        self.height = try container.decode(Double.self, forKey: .height)
    }
    // ----- v2D ----- //
    public var vx: Double {
        get { width }
        set(vx) { width = vx }
    }
    public var vy: Double {
        get { height }
        set(vy) { height = vy }
    }
}
