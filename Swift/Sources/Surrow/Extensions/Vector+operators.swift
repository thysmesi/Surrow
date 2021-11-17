//
//  File.swift
//  
//
//  Created by Corbin Bigler on 10/27/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension Vector {
    
    // ----- Point ----- //
    public static func +(lhs: Vector, rhs: Point) -> Vector {
        Vector(lhs.dx+rhs.x, lhs.dy+rhs.y)
    }
    public static func +=(lhs: inout Vector, rhs: Point) {
        lhs.dx += rhs.x
        lhs.dy += rhs.y
    }
    public static func -(lhs: Vector, rhs: Point) -> Vector {
        Vector(lhs.dx-rhs.x, lhs.dy-rhs.y)
    }
    public static func -=(lhs: inout Vector, rhs: Point) {
        lhs.dx -= rhs.x
        lhs.dy -= rhs.y
    }
    public static func *(lhs: Vector, rhs: Point) -> Vector {
        Vector(lhs.dx*rhs.x, lhs.dy*rhs.y)
    }
    public static func *=(lhs: inout Vector, rhs: Point) {
        lhs.dx *= rhs.x
        lhs.dy *= rhs.y
    }
    public static func /(lhs: Vector, rhs: Point) -> Vector {
        Vector(lhs.dx/rhs.x, lhs.dy/rhs.y)
    }
    public static func /=(lhs: inout Vector, rhs: Point) {
        lhs.dx /= rhs.x
        lhs.dy /= rhs.y
    }

    // ----- Vector ----- //
    public static func +(lhs: Vector, rhs: Vector) -> Vector {
        Vector(lhs.dx+rhs.dx, lhs.dy+rhs.dy)
    }
    public static func +=(lhs: inout Vector, rhs: Vector) {
        lhs.dx += rhs.dx
        lhs.dy += rhs.dy
    }
    public static func -(lhs: Vector, rhs: Vector) -> Vector {
        Vector(lhs.dx-rhs.dx, lhs.dy-rhs.dy)
    }
    public static func -=(lhs: inout Vector, rhs: Vector) {
        lhs.dx -= rhs.dx
        lhs.dy -= rhs.dy
    }
    public static func *(lhs: Vector, rhs: Vector) -> Vector {
        Vector(lhs.dx*rhs.dx, lhs.dy*rhs.dy)
    }
    public static func *=(lhs: inout Vector, rhs: Vector) {
        lhs.dx *= rhs.dx
        lhs.dy *= rhs.dy
    }
    public static func /(lhs: Vector, rhs: Vector) -> Vector {
        Vector(lhs.dx/rhs.dx, lhs.dy/rhs.dy)
    }
    public static func /=(lhs: inout Vector, rhs: Vector) {
        lhs.dx /= rhs.dx
        lhs.dy /= rhs.dy
    }
    
    static prefix func - (_ vector: Vector) -> Vector {
        return Vector(-vector.dx, -vector.dy)
    }

    // ----- Size ----- //
    public static func +(lhs: Vector, rhs: Size) -> Vector {
        Vector(lhs.dx+rhs.width, lhs.dy+rhs.height)
    }
    public static func +=(lhs: inout Vector, rhs: Size) {
        lhs.dx += rhs.width
        lhs.dy += rhs.height
    }
    public static func -(lhs: Vector, rhs: Size) -> Vector {
        Vector(lhs.dx-rhs.width, lhs.dy-rhs.height)
    }
    public static func -=(lhs: inout Vector, rhs: Size) {
        lhs.dx -= rhs.width
        lhs.dy -= rhs.height
    }
    public static func *(lhs: Vector, rhs: Size) -> Vector {
        Vector(lhs.dx*rhs.width, lhs.dy*rhs.height)
    }
    public static func *=(lhs: inout Vector, rhs: Size) {
        lhs.dx *= rhs.width
        lhs.dy *= rhs.height
    }
    public static func /(lhs: Vector, rhs: Size) -> Vector {
        Vector(lhs.dx/rhs.width, lhs.dy/rhs.height)
    }
    public static func /=(lhs: inout Vector, rhs: Size) {
        lhs.dx /= rhs.width
        lhs.dy /= rhs.height
    }

    // ----- Double ----- //
    public static func +(lhs: Vector, rhs: Double) -> Vector {
        Vector(lhs.dx+rhs, lhs.dy+rhs)
    }
    public static func +=(lhs: inout Vector, rhs: Double) {
        lhs.dx += rhs
        lhs.dy += rhs
    }
    public static func -(lhs: Vector, rhs: Double) -> Vector {
        Vector(lhs.dx-rhs, lhs.dy-rhs)
    }
    public static func -=(lhs: inout Vector, rhs: Double) {
        lhs.dx -= rhs
        lhs.dy -= rhs
    }
    public static func *(lhs: Vector, rhs: Double) -> Vector {
        Vector(lhs.dx*rhs, lhs.dy*rhs)
    }
    public static func *=(lhs: inout Vector, rhs: Double) {
        lhs.dx *= rhs
        lhs.dy *= rhs
    }
    public static func /(lhs: Vector, rhs: Double) -> Vector {
        Vector(lhs.dx/rhs, lhs.dy/rhs)
    }
    public static func /=(lhs: inout Vector, rhs: Double) {
        lhs.dx /= rhs
        lhs.dy /= rhs
    }
}
