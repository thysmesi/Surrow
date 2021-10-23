//
//  Box.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/22/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public class Box: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    public static var zero: Box {
        Box(position: Point.origin, size: Size.zero)
    }
    public static var unit: Box {
        Box(position: Point.origin, size: Size.unit)
    }
    
    // MARK: - Indepenants
    public let id = UUID()
    public var position: Point
    public var size: Size
    
    
    // MARK: - Dependants
    public var left: Double { position.x }
    public var right: Double { position.x + size.width }
    public var top: Double { position.y }
    public var bottom: Double { position.y + size.height}
    
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    public init(position: Point, size: Size) {
        self.position = position
        self.size = size
    }
    public init(_ box: Box) {
        self.position = box.position
        self.size = box.size
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    public var description: String {
        "Box(position: \(position), size: \(size))"
    }
    // ----- Hashable ----- //
    public static func == (lhs: Box, rhs: Box) -> Bool {
        lhs.position == rhs.position && lhs.size == rhs.size
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case position
        case size
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.position = try container.decode(Point.self, forKey: .position)
        self.size = try container.decode(Size.self, forKey: .size)
    }
    
    
    // MARK: - Operators
}
