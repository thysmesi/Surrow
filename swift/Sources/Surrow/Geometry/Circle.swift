//
//  File.swift
//  Conquerors
//
//  Created by App Dev on 9/13/21.
//

import Foundation

class Circle: Collidable {
    // ----- Static ----- //
    static var unit: Circle {
        Circle(position: Point.origin, radius: 1)
    }
    
    // ----- Independent ----- //
    var position: Point
    var radius: Double
    
    // ----- Dependent ----- //
    var bounding: Box {
        Box(position: position, size: Size(width: radius*2, height: radius*2))
    }
    
    // ----- Initializers ----- //
    init(position: Point, radius: Double) {
        self.position = position
        self.radius = radius
    }
    
    // ----- Operators ----- //
    static func *(lhs: Circle, rhs: Double) -> Circle {
        Circle(position: lhs.position, radius: lhs.radius * rhs)
    }
    static func *=(lhs: inout Circle, rhs: Double) {
        lhs.radius *= rhs
    }
    static func /(lhs: Circle, rhs: Double) -> Circle {
        Circle(position: lhs.position, radius: lhs.radius / rhs)
    }
    static func /=(lhs: inout Circle, rhs: Double) {
        lhs.radius /= rhs
    }
    
    // ----- Conformance ----- //
    func collides(with collidable: Collidable) -> Vector? {
        switch collidable {
        case is Box: return collides(with: collidable as! Box)
        case is Circle: return collides(with: collidable as! Circle)
        case is Polygon: return collides(with: collidable as! Polygon)
        default: return nil
        }
    }
    func collides(with segment: Segment) -> Vector? {
        let closest = position.closest(on: segment)
        
        let vector = position.delta(to: closest)
        if vector.length < radius {
            let normal = vector.normal
            let difference = radius - vector.length
            return -normal * difference
        }
        return nil
    }
    func collides(with box: Box) -> Vector? {
        let vector = box.collides(with: self)
        return vector == nil ? nil : -vector!
    }
    
    func collides(with circle: Circle) -> Vector? {
        let delta = circle.position.delta(to: position)
        if delta.length <= circle.radius + radius {
            return delta.normal * (circle.radius + radius - delta.length)
        }
        return nil
    }
    func collides(with polygon: Polygon) -> Vector? {
        
//        if position.within(polygon: polygon) {
//            var closest: Vector? = nil
//            for segment in polygon.segments {
//                let vector = position.delta(to: segment)
//                if closest == nil || vector.length < closest!.length {
//                    closest = -vector
//                }
//            }
//            return closest
//        }
        
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
