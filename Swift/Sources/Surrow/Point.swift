//
//  Point.swift
//  Collision
//
//  Created by App Dev on 9/13/21.
//

import Foundation

public class Point: Hashable, Decodable, CustomStringConvertible {
    // ----- Static ----- //
    public static var origin: Point {
        Point(x: 0, y: 0)
    }
    
    // ----- Independent ----- //
    public var x: Double
    public var y: Double
    
    // ----- Dependent ----- //
    
    // ----- Initializers ----- //
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    public init(_ point: Point) {
        self.x = point.x
        self.y = point.y
    }
    
    // ----- Tests ----- //
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
        
    public func cross(_ other: Point) -> Double {
        x * other.y - y * other.x
    }
    public func dot(_ other: Point) -> Double {
        x * other.x + y * other.y
    }
    public func cross(_ other: Vector) -> Double {
        x * other.dy - y * other.dx
    }
    public func dot(_ other: Vector) -> Double {
        x * other.dx + y * other.dy
    }
    
    public func closest(on line: Line) -> Point {
        let perpendicular = Line(slope: line.perpendicular, point: self)
        return perpendicular.intercects(line: line)!
    }
    public func closest(on segment: Segment) -> Point {
        let intercect = closest(on: segment.line)
        if intercect.on(segment) {
            return intercect
        }
        return distance(to: segment.p1) < distance(to: segment.p2) ? segment.p1 : segment.p2
    }
    public func closest(on polygon: Polygon) -> Point {
        let points = polygon.segments.map {closest(on: $0)}
        return points.sorted { distance(to: $0) < distance(to: $1)}[0]
    }
    public func closest(on box: Box) -> Point {
        let closest = Point.origin
        if x >= box.right {closest.x = box.right}
        else if x <= box.left {closest.x = box.left}
        if y <= box.top {closest.y = box.top}
        else if y >= box.bottom {closest.y = box.bottom}
        
        if x >= box.left && x <= box.right {closest.y = y}
        else if y >= box.top && y <= box.bottom {closest.x = x}
        return closest
    }
    public func closest(on circle: Circle) -> Point {
        circle.position + (circle.position.delta(to: self).normal * circle.radius)
    }
    public func within(_ box: Box) -> Bool {
        x >= box.left && x <= box.right && y >= box.top && y <= box.bottom
    }
    public func within(_ polygon: Polygon) -> Bool {
        let test = Segment(p1: self, p2: Point(x: 10000, y: y))
        return test.intercects(polygon: polygon).count % 2 == 1
    }
    public func within(_ circle: Circle) -> Bool {
        distance(to: circle.position) <= circle.radius
    }
    
    public func on(_ segment: Segment) -> Bool {
        x >= floor(segment.min.x) && x <= ceil(segment.max.x) &&
        y >= floor(segment.min.y) && y <= ceil(segment.max.y)
    }
    
    public func distance(to point: Point) -> Double {
        sqrt(pow(point.x-x, 2) + pow(point.y-y,2))
    }
    public func distance(to line: Line) -> Double {
        distance(to: closest(on: line))
    }
    public func distance(to segment: Segment) -> Double {
        distance(to: closest(on: segment))
    }
    public func distance(to polygon: Polygon) -> Double {
        distance(to: closest(on: polygon))
    }
    public func distance(to box: Box) -> Double {
        distance(to: closest(on: box))
    }
    public func distance(to circle: Circle) -> Double {
        distance(to: closest(on: circle))
    }
    
    public func delta(to other: Point) -> Vector {
        Vector(dx: other.x - x, dy: other.y - y)
    }
    public func delta(to line: Line) -> Vector {
        delta(to: closest(on: line))
    }
    public func delta(to segment: Segment) -> Vector {
        delta(to: closest(on: segment))
    }
    public func delta(to polygon: Polygon) -> Vector {
        delta(to: closest(on: polygon))
    }
    public func delta(to box: Box) -> Vector {
        delta(to: closest(on: box))
    }
    public func delta(to circle: Circle) -> Vector {
        delta(to: closest(on: circle))
    }
    
    // ----- Conversions ----- //
    public var vector: Vector {
        Vector(dx: x, dy: y)
    }
    
    // ----- Operators ----- //
    /* ----- TODO -----
        Point - = Point
        Point - = Vector
        Point - = Float
        Point / = Point
        Point / = Vector
        Point / = Float
     */
    public static func +(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x+rhs.x, y: lhs.y+rhs.y)
    }
    public static func +=(lhs: inout Point, rhs: Point) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    public static func +(lhs: Point, rhs: Vector) -> Point {
        Point(x: lhs.x+rhs.dx, y: lhs.y+rhs.dy)
    }
    public static func +=(lhs: inout Point, rhs: Vector) {
        lhs.x += rhs.dx
        lhs.y += rhs.dy
    }
    public static func +(lhs: Point, rhs: Double) -> Point {
        Point(x: lhs.x+rhs, y: lhs.y+rhs)
    }
    public static func +=(lhs: inout Point, rhs: Double) {
        lhs.x += rhs
        lhs.y += rhs
    }
    public static func -(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x-rhs.x, y: lhs.y-rhs.y)
    }
    public static func -=(lhs: inout Point, rhs: Point) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
    public static func -(lhs: Point, rhs: Vector) -> Point {
        Point(x: lhs.x-rhs.dx, y: lhs.y-rhs.dy)
    }
    public static func -=(lhs: inout Point, rhs: Vector) {
        lhs.x -= rhs.dx
        lhs.y -= rhs.dy
    }
    public static func -(lhs: Point, rhs: Double) -> Point {
        Point(x: lhs.x-rhs, y: lhs.y-rhs)
    }
    public static func -=(lhs: inout Point, rhs: Double) {
        lhs.x -= rhs
        lhs.y -= rhs
    }
    public static func *(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x*rhs.x, y: lhs.y*rhs.y)
    }
    public static func *=(lhs: inout Point, rhs: Point) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
    }
    public static func *(lhs: Point, rhs: Vector) -> Point {
        Point(x: lhs.x*rhs.dx, y: lhs.y*rhs.dy)
    }
    public static func *=(lhs: inout Point, rhs: Vector) {
        lhs.x *= rhs.dx
        lhs.y *= rhs.dy
    }
    public static func *(lhs: Point, rhs: Double) -> Point {
        Point(x: lhs.x*rhs, y: lhs.y*rhs)
    }
    public static func *=(lhs: inout Point, rhs: Double) {
        lhs.x *= rhs
        lhs.y *= rhs
    }
    public static func /(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x/rhs.x, y: lhs.y/rhs.y)
    }
    public static func /=(lhs: inout Point, rhs: Point) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
    }
    public static func /(lhs: Point, rhs: Vector) -> Point {
        Point(x: lhs.x/rhs.dx, y: lhs.y/rhs.dy)
    }
    public static func /=(lhs: inout Point, rhs: Vector) {
        lhs.x /= rhs.dx
        lhs.y /= rhs.dy
    }
    public static func /(lhs: Point, rhs: Double) -> Point {
        Point(x: lhs.x/rhs, y: lhs.y/rhs)
    }
    public static func /=(lhs: inout Point, rhs: Double) {
        lhs.x /= rhs
        lhs.y /= rhs
    }

    public static prefix func -(point: Point) -> Point {
        Point(x: -point.x, y: -point.y)
    }
    
    // ----- Conformance ----- //
    public var description: String {
        "(x: \(x),   y: \(y))"
    }
    
    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.x = try container.decode(Double.self, forKey: .x)
        self.y = try container.decode(Double.self, forKey: .y)
    }
    public static func == (lhs: Point, rhs: Point) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine("x\(x)y\(y)")
    }


    /* ----- TODO -----
        Codable
        Equatable
    */
}
