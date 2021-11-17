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
    var diameter: Double {
        radius*2
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
        let delta = position.delta(to: box.position)
        let halfs = box.size/2
        
        var output: Vector? = nil
        if abs(delta.dx) < halfs.width {
            output = Vector(0, halfs.width - delta.dx)
        }
        if abs(delta.dy) < halfs.height {
            let current = Vector(halfs.height - delta.dy, 0)
            if output == nil || output!.length > current.length {
                output = current
            }
        }
        return output
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
