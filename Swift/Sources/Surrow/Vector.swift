//
//  Vector.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/22/21.
//

import Foundation

@available(macOS 10.15, *)
struct Vector: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    static var zero: Vector {
        Vector(0, 0)
    }
    
    // MARK: - Indepenants
    let id = UUID()
    var dx: Double
    var dy: Double
    
    
    // MARK: - Dependants
    var point: Point { Point(dx, dy) }
    var size: Size { Size(dx, dy) }
    
    var length: Double {
        abs(sqrt(pow(dx,2)+pow(dy,2)))
    }
    var degrees: Double {
        atan2(dy, dx) / (Double.pi / 180)
    }
    var normal: Vector {
        if(length == 0) {
            return Vector(Double.random(in: -1...1), Double.random(in: -1...1)).normal
        } else {
            return Vector(dx/length, dy/length)
        }
    }
    var perpendicular: Vector {
        Vector(dy, -dx)
    }
    
    
    // MARK: - Adjustments
    func cross(_ other: Vector) -> Double {
        dx * other.dy - dy * other.dx
    }
    func dot(_ other: Vector) -> Double {
        dx * other.dx + dy * other.dy
    }
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    init(_ dx: Double, _ dy: Double) {
        self.dx = dx
        self.dy = dy
    }
    init(degrees: Double) {
        self.dx = cos(degrees.toRadians)
        self.dy = sin(degrees.toRadians)
    }
    init(_ vector: Vector) {
        self.dx = vector.dx
        self.dy = vector.dy
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    var description: String {
        "Vector(dx: \(dx), dy: \(dy))"
    }
    // ----- Hashable ----- //
    static func == (lhs: Vector, rhs: Vector) -> Bool {
        lhs.dx == rhs.dx && lhs.dy == rhs.dy
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case dx
        case dy
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dx = try container.decode(Double.self, forKey: .dx)
        self.dy = try container.decode(Double.self, forKey: .dy)
    }
    
    
    // MARK: - Operators
    static func +(lhs: Vector, rhs: Point) -> Vector {
        Vector(lhs.dx+rhs.x, lhs.dy+rhs.y)
    }
    static func +=(lhs: inout Vector, rhs: Point) {
        lhs.dx += rhs.x
        lhs.dy += rhs.y
    }
    static func +(lhs: Vector, rhs: Vector) -> Vector {
        Vector(lhs.dx+rhs.dx, lhs.dy+rhs.dy)
    }
    static func +=(lhs: inout Vector, rhs: Vector) {
        lhs.dx += rhs.dx
        lhs.dy += rhs.dy
    }
    static func +(lhs: Vector, rhs: Double) -> Vector {
        Vector(lhs.dx+rhs, lhs.dy+rhs)
    }
    static func +=(lhs: inout Vector, rhs: Double) {
        lhs.dx += rhs
        lhs.dy += rhs
    }
    static func -(lhs: Vector, rhs: Point) -> Vector {
        Vector(lhs.dx-rhs.x, lhs.dy-rhs.y)
    }
    static func -=(lhs: inout Vector, rhs: Point) {
        lhs.dx -= rhs.x
        lhs.dy -= rhs.y
    }
    static func -(lhs: Vector, rhs: Vector) -> Vector {
        Vector(lhs.dx-rhs.dx, lhs.dy-rhs.dy)
    }
    static func -=(lhs: inout Vector, rhs: Vector) {
        lhs.dx -= rhs.dx
        lhs.dy -= rhs.dy
    }
    static func -(lhs: Vector, rhs: Double) -> Vector {
        Vector(lhs.dx-rhs, lhs.dy-rhs)
    }
    static func -=(lhs: inout Vector, rhs: Double) {
        lhs.dx -= rhs
        lhs.dy -= rhs
    }
    static func *(lhs: Vector, rhs: Point) -> Vector {
        Vector(lhs.dx*rhs.x, lhs.dy*rhs.y)
    }
    static func *=(lhs: inout Vector, rhs: Point) {
        lhs.dx *= rhs.x
        lhs.dy *= rhs.y
    }
    static func *(lhs: Vector, rhs: Vector) -> Vector {
        Vector(lhs.dx*rhs.dx, lhs.dy*rhs.dy)
    }
    static func *=(lhs: inout Vector, rhs: Vector) {
        lhs.dx *= rhs.dx
        lhs.dy *= rhs.dy
    }
    static func *(lhs: Vector, rhs: Double) -> Vector {
        Vector(lhs.dx*rhs, lhs.dy*rhs)
    }
    static func *=(lhs: inout Vector, rhs: Double) {
        lhs.dx *= rhs
        lhs.dy *= rhs
    }
    static func /(lhs: Vector, rhs: Point) -> Vector {
        Vector(lhs.dx/rhs.x, lhs.dy/rhs.y)
    }
    static func /=(lhs: inout Vector, rhs: Point) {
        lhs.dx /= rhs.x
        lhs.dy /= rhs.y
    }
    static func /(lhs: Vector, rhs: Vector) -> Vector {
        Vector(lhs.dx/rhs.dx, lhs.dy/rhs.dy)
    }
    static func /=(lhs: inout Vector, rhs: Vector) {
        lhs.dx /= rhs.dx
        lhs.dy /= rhs.dy
    }
    static func /(lhs: Vector, rhs: Double) -> Vector {
        Vector(lhs.dx/rhs, lhs.dy/rhs)
    }
    static func /=(lhs: inout Vector, rhs: Double) {
        lhs.dx /= rhs
        lhs.dy /= rhs
    }
}
