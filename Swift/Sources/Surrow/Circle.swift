//
//  Circle.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/22/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public class Circle: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    public static var zero: Circle {
        Circle(position: Point.origin, radius: 0)
    }
    public static var unit: Circle {
        Circle(position: Point.origin, radius: 1)
    }
    
    // MARK: - Indepenants
    public let id = UUID()
    public var position: Point
    public var radius: Double
    
    
    // MARK: - Dependants
    
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    public init(position: Point, radius: Double) {
        self.position = position
        self.radius = radius
    }
    public init(_ circle: Circle) {
        self.position = circle.position
        self.radius = circle.radius
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    public var description: String {
        "Circle(position: \(position), radius: \(radius))"
    }
    // ----- Hashable ----- //
    public static func == (lhs: Circle, rhs: Circle) -> Bool {
        lhs.position == rhs.position && lhs.radius == rhs.radius
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case position
        case radius
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.position = try container.decode(Point.self, forKey: .position)
        self.radius = try container.decode(Double.self, forKey: .radius)
    }
    
    
    // MARK: - Operators
}
