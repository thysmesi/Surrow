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
    public var min: Double { Swift.min(width, height) }
    public var max: Double { Swift.max(width, height) }
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    public init(_ width: Double, _ height: Double) {
        self.width = width
        self.height = height
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
    
    
    // MARK: - Operators
    public static func /(lhs: Size, rhs: Double) -> Size {
        Size(lhs.width/rhs, lhs.height/rhs)
    }
    
    static prefix func -(size: Size) -> Size {
        return Size(-size.width, -size.height)
    }
}
