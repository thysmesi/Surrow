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
    public var diameter: Double {
        radius*2
    }
    public var size: Size {
        Size(diameter)
    }
    
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    public func collides(with segment: Segment) -> Vector? {
        let closest = position.closest(on: segment)

        let vector = position.delta(to: closest)
        if vector.length < radius {
            let normal = vector.normal
            let difference = radius - vector.length
            return -normal * difference
        }
        return nil
    }
    public func collides(with other: Circle) -> Vector? {
        let delta = other.position.delta(to: position)
        let sum = radius + other.radius
        let length = delta.length
        if length < sum {
            return delta.normal * (sum - length)
        }
        return nil
    }
    public func collides(with box: Box) -> Vector? {
        let closestX = max(box.left,min(box.right,position.x))
        let closestY = max(box.top,min(box.bottom,position.y))

        let distanceX = position.x - closestX;
        let distanceY = position.y - closestY;

        let distanceSquared = (distanceX * distanceX) + (distanceY * distanceY);
        if distanceSquared < (radius * radius) {
            let closest = Point(closestX, closestY)
            let delta = position.delta(to: closest)
            return -delta.normal * (radius - delta.length)
        }

        return nil
    }
    public func collides(with box: Box, degrees: Double) -> Vector? {
        let projected = Circle(position: position.rotated(around: box.position, degrees: -degrees), radius: radius)
        
        if let vector = projected.collides(with: box) {
            return vector.rotated(degrees: degrees)
        }
        return nil
    }
    
    
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
