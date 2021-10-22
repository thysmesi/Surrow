//
//  Vector.swift
//  Collision
//
//  Created by App Dev on 9/13/21.
//

import Foundation

public class Vector: CustomStringConvertible {
    // ----- Static ----- //
    static var zero: Vector {
        Vector(dx: 0, dy: 0)
    }
    
    // ----- Independent ----- //
    var dx: Double
    var dy: Double
    
    // ----- Dependent ----- //
    
    var normal: Vector {
        if(length == 0) {
            return Vector(dx: Double.random(in: -1...1), dy: Double.random(in: -1...1)).normal
        } else {
            return Vector(dx: dx/length, dy: dy/length)
        }
    }
    var perpendicular: Vector {
        Vector(dx: dy, dy: -dx)
    }
    var length: Double {
        abs(sqrt(pow(dx,2)+pow(dy,2)))
    }
    var degrees: Double {
        atan2(dy, dx) / (Double.pi / 180)
    }
    
    // ----- Initializers ----- //
    init(dx: Double, dy: Double) {
        self.dx = dx
        self.dy = dy
    }
    init(angle: Double) {
        let radians = angle * (Double.pi / 180)
        
        self.dx = cos(radians)
        self.dy = sin(radians)
    }
    init(_ other: Vector) {
        self.dx = other.dx
        self.dy = other.dy
    }
    
    // ----- Tests ----- //
    func cross(_ other: Vector) -> Double {
        dx * other.dy - dy * other.dx
    }
    func dot(_ other: Vector) -> Double {
        dx * other.dx + dy * other.dy
    }
    func cross(_ other: Point) -> Double {
        dx * other.y - dy * other.x
    }
    func dot(_ other: Point) -> Double {
        dx * other.x + dy * other.y
    }
    
    // ----- Conversions ----- //
    var size: Size {
        Size(width: dx, height: dy)
    }
    
    // ----- Operators ----- //
    /* ----- TODO -----
        Vector / = Point
        Vector / = Vector
        Vector / = Float
    */
    static func +(lhs: Vector, rhs: Point) -> Vector {
        Vector(dx: lhs.dx+rhs.x, dy: lhs.dy+rhs.y)
    }
    static func +=(lhs: inout Vector, rhs: Point) {
        lhs.dx += rhs.x
        lhs.dy += rhs.y
    }
    static func +(lhs: Vector, rhs: Vector) -> Vector {
        Vector(dx: lhs.dx+rhs.dx, dy: lhs.dy+rhs.dy)
    }
    static func +=(lhs: inout Vector, rhs: Vector) {
        lhs.dx += rhs.dx
        lhs.dy += rhs.dy
    }
    static func +(lhs: Vector, rhs: Double) -> Vector {
        Vector(dx: lhs.dx+rhs, dy: lhs.dy+rhs)
    }
    static func +=(lhs: inout Vector, rhs: Double) {
        lhs.dx += rhs
        lhs.dy += rhs
    }
    static func -(lhs: Vector, rhs: Point) -> Vector {
        Vector(dx: lhs.dx-rhs.x, dy: lhs.dy-rhs.y)
    }
    static func -=(lhs: inout Vector, rhs: Point) {
        lhs.dx -= rhs.x
        lhs.dy -= rhs.y
    }
    static func -(lhs: Vector, rhs: Vector) -> Vector {
        Vector(dx: lhs.dx-rhs.dx, dy: lhs.dy-rhs.dy)
    }
    static func -=(lhs: inout Vector, rhs: Vector) {
        lhs.dx -= rhs.dx
        lhs.dy -= rhs.dy
    }
    static func -(lhs: Vector, rhs: Double) -> Vector {
        Vector(dx: lhs.dx-rhs, dy: lhs.dy-rhs)
    }
    static func -=(lhs: inout Vector, rhs: Double) {
        lhs.dx -= rhs
        lhs.dy -= rhs
    }
    static func *(lhs: Vector, rhs: Point) -> Vector {
        Vector(dx: lhs.dx*rhs.x, dy: lhs.dy*rhs.y)
    }
    static func *=(lhs: inout Vector, rhs: Point) {
        lhs.dx *= rhs.x
        lhs.dy *= rhs.y
    }
    static func *(lhs: Vector, rhs: Vector) -> Vector {
        Vector(dx: lhs.dx*rhs.dx, dy: lhs.dy*rhs.dy)
    }
    static func *=(lhs: inout Vector, rhs: Vector) {
        lhs.dx *= rhs.dx
        lhs.dy *= rhs.dy
    }
    static func *(lhs: Vector, rhs: Double) -> Vector {
        Vector(dx: lhs.dx*rhs, dy: lhs.dy*rhs)
    }
    static func *=(lhs: inout Vector, rhs: Double) {
        lhs.dx *= rhs
        lhs.dy *= rhs
    }
    static func /(lhs: Vector, rhs: Point) -> Vector {
        Vector(dx: lhs.dx/rhs.x, dy: lhs.dy/rhs.y)
    }
    static func /=(lhs: inout Vector, rhs: Point) {
        lhs.dx /= rhs.x
        lhs.dy /= rhs.y
    }
    static func /(lhs: Vector, rhs: Vector) -> Vector {
        Vector(dx: lhs.dx/rhs.dx, dy: lhs.dy/rhs.dy)
    }
    static func /=(lhs: inout Vector, rhs: Vector) {
        lhs.dx /= rhs.dx
        lhs.dy /= rhs.dy
    }
    static func /(lhs: Vector, rhs: Double) -> Vector {
        Vector(dx: lhs.dx/rhs, dy: lhs.dy/rhs)
    }
    static func /=(lhs: inout Vector, rhs: Double) {
        lhs.dx /= rhs
        lhs.dy /= rhs
    }
    
    static prefix func -(vector: Vector) -> Vector {
        Vector(dx: -vector.dx, dy: -vector.dy)
    }

    // ----- Conformance ----- //
    
    var description: String {
        "(dx: \(dx),   dy: \(dy))"
    }
    
    /* ----- TODO -----
        Codable
        Hashable
        Equatable
    */
}
