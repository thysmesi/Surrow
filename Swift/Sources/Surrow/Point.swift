//
//  Point.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/22/21.
//

import Foundation
import simd

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public struct Point: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    public static var origin: Point {
        Point(0, 0)
    }
    
    // MARK: - Indepenants
    public let id = UUID()
    public var x: Double
    public var y: Double
    
    
    // MARK: - Dependants
    public var vector: Vector { Vector(x, y) }
    public var size: Size { Size(x, y) }
    
    
    // MARK: - Adjustments
    public func rotated(around other: Point = Point.origin, degrees: Double) -> Point {
        let radians = degrees * (Double.pi/180)
        let s = sin(radians)
        let c = cos(radians)
        
        var point = Point(self) - other
        
        let x = point.x
        point.x = (point.x * c - point.y * s)
        point.y = (x * s + point.y * c)
        point += other

        return point
    }

    
    // MARK: - Testing
    public func closest(on line: Line) -> Point {
        return Line(slope: line.perpendicular, point: self).intercects(line)!
    }
    public func closest(on segment: Segment) -> Point {
        var tests = [segment.p1, segment.p2]
        let closest = closest(on: segment.line)
        if closest.fluffy(on: segment) {
            tests.append(closest)
        }
        return tests.sorted {distance(to: $0) < distance(to: $1)}[0]
    }
    
    public func distance(to other: Point) -> Double {
        sqrt(pow(other.x-x, 2) + pow(other.y-y,2))
    }
    public func distance(to line: Line) -> Double {
        distance(to: closest(on: line))
    }
    public func distance(to segment: Segment) -> Double {
        distance(to: closest(on: segment))
    }
    
    public func delta(to other: Point) -> Vector {
        Vector(other.x - x, other.y - y)
    }
    public func delta(to line: Line) -> Vector {
        delta(to: closest(on: line))
    }
    public func delta(to segment: Segment) -> Vector {
        delta(to: closest(on: segment))
    }

    public func within(_ circle: Circle) -> Bool {
        distance(to: circle.position) <= circle.radius
    }
    public func within(_ box: Box) -> Bool {
        x >= box.left && x <= box.right && y >= box.top && y <= box.bottom
    }
    public func within(_ polygon: Polygon) -> Bool {
        func sign(point: Point, segment: Segment) -> Double {
            (point.x - segment.p2.x) * (segment.p1.y - segment.p2.y) - (segment.p1.x - segment.p2.x) * (point.y - segment.p2.y)
        }
        for triangle in polygon.triangles {
            let d1 = sign(point: self, segment: triangle.sides[0])
            let d2 = sign(point: self, segment: triangle.sides[1])
            let d3 = sign(point: self, segment: triangle.sides[2])
            
            if !(((d1 < 0) || (d2 < 0) || (d3 < 0)) && ((d1 > 0) || (d2 > 0) || (d3 > 0))) {
                return true
            }
        }

        return false
    }
    
    public func fluffy(on segment: Segment) -> Bool{
        func ru(_ value: Double) -> Double {
            ceil(value * 1000) / 1000.0
        }
        func rd(_ value: Double) -> Double {
            floor(value * 1000) / 1000.0
        }
        return x >= rd(segment.min.dx) && x <= ru(segment.max.dx) && y >= rd(segment.min.dy) && y <= ru(segment.max.dy)
    }
    
    
    // MARK: - Initializers
    public init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
    public init(_ point: Point) {
        self.x = point.x
        self.y = point.y
    }
    public init(_ simd: SIMD2<Float>) {
        self.x = Double(simd.x)
        self.y = Double(simd.y)
    }
    public init(_ simd: SIMD2<Double>) {
        self.x = simd.x
        self.y = simd.y
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    public var description: String {
        "Point(x: \(x), y: \(y))"
    }
    // ----- Hashable ----- //
    public static func == (lhs: Point, rhs: Point) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.x = try container.decode(Double.self, forKey: .x)
        self.y = try container.decode(Double.self, forKey: .y)
    }
    
    
    // MARK: - Operators
    public static func +(lhs: Point, rhs: Point) -> Point {
        Point(lhs.x+rhs.x, lhs.y+rhs.y)
    }
    public static func +=(lhs: inout Point, rhs: Point) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    public static func +(lhs: Point, rhs: Vector) -> Point {
        Point(lhs.x+rhs.dx, lhs.y+rhs.dy)
    }
    public static func +=(lhs: inout Point, rhs: Vector) {
        lhs.x += rhs.dx
        lhs.y += rhs.dy
    }
    public static func +(lhs: Point, rhs: Size) -> Point {
        Point(lhs.x+rhs.width, lhs.y+rhs.height)
    }
    public static func +=(lhs: inout Point, rhs: Size) {
        lhs.x += rhs.width
        lhs.y += rhs.height
    }
    public static func +(lhs: Point, rhs: Double) -> Point {
        Point(lhs.x+rhs, lhs.y+rhs)
    }
    public static func +=(lhs: inout Point, rhs: Double) {
        lhs.x += rhs
        lhs.y += rhs
    }
    public static func -(lhs: Point, rhs: Point) -> Point {
        Point(lhs.x-rhs.x, lhs.y-rhs.y)
    }
    public static func -=(lhs: inout Point, rhs: Point) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
    public static func -(lhs: Point, rhs: Vector) -> Point {
        Point(lhs.x-rhs.dx, lhs.y-rhs.dy)
    }
    public static func -=(lhs: inout Point, rhs: Vector) {
        lhs.x -= rhs.dx
        lhs.y -= rhs.dy
    }
    public static func -(lhs: Point, rhs: Double) -> Point {
        Point(lhs.x-rhs, lhs.y-rhs)
    }
    public static func -=(lhs: inout Point, rhs: Double) {
        lhs.x -= rhs
        lhs.y -= rhs
    }
    public static func *(lhs: Point, rhs: Point) -> Point {
        Point(lhs.x*rhs.x, lhs.y*rhs.y)
    }
    public static func *=(lhs: inout Point, rhs: Point) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
    }
    public static func *(lhs: Point, rhs: Vector) -> Point {
        Point(lhs.x*rhs.dx, lhs.y*rhs.dy)
    }
    public static func *=(lhs: inout Point, rhs: Vector) {
        lhs.x *= rhs.dx
        lhs.y *= rhs.dy
    }
    public static func *(lhs: Point, rhs: Double) -> Point {
        Point(lhs.x*rhs, lhs.y*rhs)
    }
    public static func *=(lhs: inout Point, rhs: Double) {
        lhs.x *= rhs
        lhs.y *= rhs
    }
    public static func /(lhs: Point, rhs: Point) -> Point {
        Point(lhs.x/rhs.x, lhs.y/rhs.y)
    }
    public static func /=(lhs: inout Point, rhs: Point) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
    }
    public static func /(lhs: Point, rhs: Vector) -> Point {
        Point(lhs.x/rhs.dx, lhs.y/rhs.dy)
    }
    public static func /=(lhs: inout Point, rhs: Vector) {
        lhs.x /= rhs.dx
        lhs.y /= rhs.dy
    }
    public static func /(lhs: Point, rhs: Size) -> Point {
        Point(lhs.x/rhs.width, lhs.y/rhs.height)
    }
    public static func /=(lhs: inout Point, rhs: Size) {
        lhs.x /= rhs.width
        lhs.y /= rhs.height
    }
    public static func /(lhs: Point, rhs: Double) -> Point {
        Point(lhs.x/rhs, lhs.y/rhs)
    }
    public static func /=(lhs: inout Point, rhs: Double) {
        lhs.x /= rhs
        lhs.y /= rhs
    }
}
