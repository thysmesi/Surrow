//
//  File.swift
//  Conquerors
//
//  Created by App Dev on 9/13/21.
//

import Foundation

public class Circle {
    // ----- Static ----- //
    public static var unit: Circle {
        Circle(position: Point.origin, radius: 1)
    }
    
    // ----- Independent ----- //
    public var position: Point
    public var radius: Double
    
    // ----- Dependent ----- //
    public var bounding: Box {
        Box(position: position, size: Size(width: radius*2, height: radius*2))
    }
    
    // ----- Initializers ----- //
    public init(position: Point, radius: Double) {
        self.position = position
        self.radius = radius
    }
    
    // ----- Operators ----- //
    public static func *(lhs: Circle, rhs: Double) -> Circle {
        Circle(position: lhs.position, radius: lhs.radius * rhs)
    }
    public static func *=(lhs: inout Circle, rhs: Double) {
        lhs.radius *= rhs
    }
    public static func /(lhs: Circle, rhs: Double) -> Circle {
        Circle(position: lhs.position, radius: lhs.radius / rhs)
    }
    public static func /=(lhs: inout Circle, rhs: Double) {
        lhs.radius /= rhs
    }
    
    // ----- Conformance ----- //
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
    public func collides(with box: Box) -> Vector? {
        let vector = box.collides(with: self)
        return vector == nil ? nil : -vector!
    }
    
    public func collides(with circle: Circle) -> Vector? {
        let delta = circle.position.delta(to: position)
        if delta.length <= circle.radius + radius {
            return delta.normal * (circle.radius + radius - delta.length)
        }
        return nil
    }
    public func collides(with polygon: Polygon) -> Vector? {
        var vectors: [Vector] = []
        for segment in polygon.segments {
            if let vector = collides(with: segment) {
                vectors.append(vector)
            }
        }
        
        if vectors.count == 0 { return nil }
        
        return vectors.sorted {$0.length > $1.length} [0]
    }
    /* ----- TODO -----
        Codable
        Hashable
        Equatable
        CustomStringConvertible
    */
}
