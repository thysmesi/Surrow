//
//  Vector.swift
//  Collision
//
//  Created by App Dev on 9/13/21.
//

import Foundation

public class Vector: CustomStringConvertible {
    // ----- Static ----- //
    public static var zero: Vector {
        Vector(dx: 0, dy: 0)
    }
    
    // ----- Independent ----- //
    public var dx: Double
    public var dy: Double
    
    // ----- Dependent ----- //
    
    public var normal: Vector {
        if(length == 0) {
            return Vector(dx: Double.random(in: -1...1), dy: Double.random(in: -1...1)).normal
        } else {
            return Vector(dx: dx/length, dy: dy/length)
        }
    }
    public var perpendicular: Vector {
        Vector(dx: dy, dy: -dx)
    }
    public var length: Double {
        abs(sqrt(pow(dx,2)+pow(dy,2)))
    }
    public var degrees: Double {
        atan2(dy, dx) / (Double.pi / 180)
    }
    
    // ----- Initializers ----- //
    public init(dx: Double, dy: Double) {
        self.dx = dx
        self.dy = dy
    }
    public init(angle: Double) {
        let radians = angle * (Double.pi / 180)
        
        self.dx = cos(radians)
        self.dy = sin(radians)
    }
    public init(_ other: Vector) {
        self.dx = other.dx
        self.dy = other.dy
    }
    
    // ----- Tests ----- //
    public func cross(_ other: Vector) -> Double {
        dx * other.dy - dy * other.dx
    }
    public func dot(_ other: Vector) -> Double {
        dx * other.dx + dy * other.dy
    }
    public func cross(_ other: Point) -> Double {
        dx * other.y - dy * other.x
    }
    public func dot(_ other: Point) -> Double {
        dx * other.x + dy * other.y
    }
    
    // ----- Conversions ----- //
    public var size: Size {
        Size(width: dx, height: dy)
    }
    
    // ----- Operators ----- //
    /* ----- TODO -----
        Vector / = Point
        Vector / = Vector
        Vector / = Float
    */
    public static func +(lhs: Vector, rhs: Point) -> Vector {
        Vector(dx: lhs.dx+rhs.x, dy: lhs.dy+rhs.y)
    }
    public static func +=(lhs: inout Vector, rhs: Point) {
        lhs.dx += rhs.x
        lhs.dy += rhs.y
    }
    public static func +(lhs: Vector, rhs: Vector) -> Vector {
        Vector(dx: lhs.dx+rhs.dx, dy: lhs.dy+rhs.dy)
    }
    public static func +=(lhs: inout Vector, rhs: Vector) {
        lhs.dx += rhs.dx
        lhs.dy += rhs.dy
    }
    public static func +(lhs: Vector, rhs: Double) -> Vector {
        Vector(dx: lhs.dx+rhs, dy: lhs.dy+rhs)
    }
    public static func +=(lhs: inout Vector, rhs: Double) {
        lhs.dx += rhs
        lhs.dy += rhs
    }
    public static func -(lhs: Vector, rhs: Point) -> Vector {
        Vector(dx: lhs.dx-rhs.x, dy: lhs.dy-rhs.y)
    }
    public static func -=(lhs: inout Vector, rhs: Point) {
        lhs.dx -= rhs.x
        lhs.dy -= rhs.y
    }
    public static func -(lhs: Vector, rhs: Vector) -> Vector {
        Vector(dx: lhs.dx-rhs.dx, dy: lhs.dy-rhs.dy)
    }
    public static func -=(lhs: inout Vector, rhs: Vector) {
        lhs.dx -= rhs.dx
        lhs.dy -= rhs.dy
    }
    public static func -(lhs: Vector, rhs: Double) -> Vector {
        Vector(dx: lhs.dx-rhs, dy: lhs.dy-rhs)
    }
    public static func -=(lhs: inout Vector, rhs: Double) {
        lhs.dx -= rhs
        lhs.dy -= rhs
    }
    public static func *(lhs: Vector, rhs: Point) -> Vector {
        Vector(dx: lhs.dx*rhs.x, dy: lhs.dy*rhs.y)
    }
    public static func *=(lhs: inout Vector, rhs: Point) {
        lhs.dx *= rhs.x
        lhs.dy *= rhs.y
    }
    public static func *(lhs: Vector, rhs: Vector) -> Vector {
        Vector(dx: lhs.dx*rhs.dx, dy: lhs.dy*rhs.dy)
    }
    public static func *=(lhs: inout Vector, rhs: Vector) {
        lhs.dx *= rhs.dx
        lhs.dy *= rhs.dy
    }
    public static func *(lhs: Vector, rhs: Double) -> Vector {
        Vector(dx: lhs.dx*rhs, dy: lhs.dy*rhs)
    }
    public static func *=(lhs: inout Vector, rhs: Double) {
        lhs.dx *= rhs
        lhs.dy *= rhs
    }
    public static func /(lhs: Vector, rhs: Point) -> Vector {
        Vector(dx: lhs.dx/rhs.x, dy: lhs.dy/rhs.y)
    }
    public static func /=(lhs: inout Vector, rhs: Point) {
        lhs.dx /= rhs.x
        lhs.dy /= rhs.y
    }
    public static func /(lhs: Vector, rhs: Vector) -> Vector {
        Vector(dx: lhs.dx/rhs.dx, dy: lhs.dy/rhs.dy)
    }
    public static func /=(lhs: inout Vector, rhs: Vector) {
        lhs.dx /= rhs.dx
        lhs.dy /= rhs.dy
    }
    public static func /(lhs: Vector, rhs: Double) -> Vector {
        Vector(dx: lhs.dx/rhs, dy: lhs.dy/rhs)
    }
    public static func /=(lhs: inout Vector, rhs: Double) {
        lhs.dx /= rhs
        lhs.dy /= rhs
    }
    
    public static prefix func -(vector: Vector) -> Vector {
        Vector(dx: -vector.dx, dy: -vector.dy)
    }

    // ----- Conformance ----- //
    
    public var description: String {
        "(dx: \(dx),   dy: \(dy))"
    }
    
    /* ----- TODO -----
        Codable
        Hashable
        Equatable
    */
}
