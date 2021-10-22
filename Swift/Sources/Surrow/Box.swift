//
//  Box.swift
//  Conquerors
//
//  Created by App Dev on 9/14/21.
//

import Foundation

public class Box: Collidable, CustomStringConvertible {
    // ----- Static ----- //
    var unit: Box {
        Box(x: 0, y: 0, width: 1, height: 1)
    }
    
    // ----- Independent ----- //
    public var position: Point
    var size: Size
    
    // ----- Dependent ----- //
    var left: Double {
        position.x - (size.width / 2)
    }
    var right: Double {
        position.x + (size.width / 2)
    }
    var top: Double {
        position.y - (size.height / 2)
    }
    var bottom: Double {
        position.y + (size.height / 2)
    }
        
    // ----- Initializers ----- //
    init(position: Point, size: Size) {
        self.position = position
        self.size = size
    }
    init(x: Double, y: Double, width: Double, height: Double) {
        self.position = Point(x:x, y: y)
        self.size = Size(width: width, height: height)
    }
    
    // ----- Tests ----- //
    public func collides(with collidable: Collidable) -> Vector? {
        switch collidable {
        case is Box: return collides(with: collidable as! Box)
        case is Circle: return collides(with: collidable as! Circle)
        case is Polygon: return collides(with: collidable as! Polygon)
        default: return nil
        }
    }
    public func collides(with segment: Segment) -> Vector? {
        return nil
    }
    public func collides(with box: Box) -> Vector? {
        let vX = right - box.right
        let vY = bottom - box.bottom
        let hWidths = (size.width/2) + (box.size.width / 2)
        let hHeights = (size.height/2) + (box.size.height / 2)
        var vector: Vector? = nil
        
        if abs(vX) < hWidths && abs(vY) < hHeights {
            let oX = hWidths - abs(vX)
            let oY = hHeights - abs(vY)
            if oX >= oY {
                if vY > 0 {
                    vector = Vector(dx: 0, dy: oY)
                } else {
                    vector = Vector(dx: 0, dy: -oY)
                }
            } else {
                if vX > 0 {
                    vector = Vector(dx: oX, dy: 0)
                } else {
                    vector = Vector(dx: -oX, dy: 0)
                }
            }
        }
        
        return vector
    }
    public func collides(with circle: Circle) -> Vector? {
        // ----- source: https://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection
        
        let delta = circle.position.delta(to: position)
        
        let hWidth = size.width / 2
        let hHeight = size.height / 2
        
        if delta.dx > (hWidth + circle.radius) || delta.dy > (hHeight + circle.radius) { return nil }
        
        var pointVector: Vector = Vector.zero
        for point in polygon.points {
            if point.within(circle: circle) {
                let vector = circle.position.delta(to: point)
                pointVector = vector.normal * (circle.radius - vector.length)
            }
        }
        
        var linearVector: Vector = Vector.zero
        let horizontal = Vector(dx: hWidth + circle.radius - delta.dx, dy: 0)
        let vertical = Vector(dx: 0, dy: hHeight + circle.radius - delta.dy)
        linearVector = horizontal.length < vertical.length ? horizontal : vertical
        
        return pointVector.length < linearVector.length ? pointVector : linearVector
    }
    public func collides(with polygon: Polygon) -> Vector? {
        self.polygon.collides(with: polygon)
    }
    
    // ----- Conversions ----- //
    var polygon: Polygon {
        Polygon(relatives: [Point(x: -(size.width / 2), y: -(size.height / 2)), Point(x: (size.width / 2), y: -(size.height / 2)), Point(x: (size.width / 2), y: (size.height / 2)), Point(x: -(size.width / 2), y: (size.height / 2))], position: position)
    }
    
    // ----- Operators ----- //
    /* ----- TODO -----
        Box *= Float
        Box / = Float
    */
    static func *(lhs: Box, rhs: Double) -> Box {
        Box(position: lhs.position, size: lhs.size * rhs)
    }
    
    // ----- Conformance ----- //
    public var description: String {
        "x: \(position.x), y: \(position.y), width: \(size.width), height: \(size.height)"
    }
    
    /* ----- TODO -----
        Codable
        Hashable
        Equatable
        CustomStringConvertible    
    */
    public var bounding: Box { self }
}
