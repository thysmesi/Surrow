//
//  Point.swift
//  Collision
//
//  Created by App Dev on 9/13/21.
//

import Foundation

class Point: Hashable, Decodable, CustomStringConvertible {
    // ----- Static ----- //
    static var origin: Point {
        Point(x: 0, y: 0)
    }
    
    // ----- Independent ----- //
    var x: Double
    var y: Double
    
    // ----- Dependent ----- //
    
    // ----- Initializers ----- //
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    init(_ point: Point) {
        self.x = point.x
        self.y = point.y
    }
    
    // ----- Tests ----- //
    func rotated(around other: Point = Point.origin, degrees: Double) -> Point {
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
        
    func cross(_ other: Point) -> Double {
        x * other.y - y * other.x
    }
    func dot(_ other: Point) -> Double {
        x * other.x + y * other.y
    }
    func cross(_ other: Vector) -> Double {
        x * other.dy - y * other.dx
    }
    func dot(_ other: Vector) -> Double {
        x * other.dx + y * other.dy
    }
    
    func closest(on line: Line) -> Point {
        let perpendicular = Line(slope: line.perpendicular, point: self)
        return perpendicular.intercects(line: line)!
    }
    func closest(on segment: Segment) -> Point {
        let intercect = closest(on: segment.line)
        if intercect.within(box: segment.bounding) {
            return intercect
        }
        return distance(to: segment.p1) < distance(to: segment.p2) ? segment.p1 : segment.p2
    }
    func closest(on polygon: Polygon) -> Point {
        let points = polygon.segments.map {closest(on: $0)}
        return points.sorted { distance(to: $0) < distance(to: $1)}[0]
    }
    func closest(on box: Box) -> Point {
        let closest = Point.origin
        if x >= box.right {closest.x = box.right}
        else if x <= box.left {closest.x = box.left}
        if y <= box.top {closest.y = box.top}
        else if y >= box.bottom {closest.y = box.bottom}
        
        if x >= box.left && x <= box.right {closest.y = y}
        else if y >= box.top && y <= box.bottom {closest.x = x}
        return closest
    }
    func closest(on circle: Circle) -> Point {
        circle.position + (circle.position.delta(to: self).normal * circle.radius)
    }

    func within(_ collidable: Collidable) -> Bool {
        switch collidable {
        case is Box: return within(box: collidable as! Box)
        case is Circle: return within(circle: collidable as! Circle)
        case is Polygon: return within(polygon: collidable as! Polygon)
        default: return false
        }
    }
    func within(box: Box) -> Bool {
//        x >= floor(1000.0 * box.left) / 1000.0 && x <= ceil(1000.0 * box.right) / 1000.0 && y >= floor(1000.0 * box.top) / 1000.0 && y <= ceil(1000.0 * box.bottom) / 1000.0
        x >= box.left && x <= box.right && y >= box.top && y <= box.bottom
    }
    func within(polygon: Polygon) -> Bool {
        let test = Segment(p1: self, p2: Point(x: 65_535, y: y))
        return test.intercects(polygon: polygon).count % 2 == 1
    }
    func within(circle: Circle) -> Bool {
        distance(to: circle.position) <= circle.radius
    }
    
    func distance(to point: Point) -> Double {
        sqrt(pow(point.x-x, 2) + pow(point.y-y,2))
    }
    func distance(to line: Line) -> Double {
        distance(to: closest(on: line))
    }
    func distance(to segment: Segment) -> Double {
        distance(to: closest(on: segment))
    }
    func distance(to polygon: Polygon) -> Double {
        distance(to: closest(on: polygon))
    }
    func distance(to box: Box) -> Double {
        distance(to: closest(on: box))
    }
    func distance(to circle: Circle) -> Double {
        distance(to: closest(on: circle))
    }
    
    func delta(to other: Point) -> Vector {
        Vector(dx: other.x - x, dy: other.y - y)
    }
    func delta(to line: Line) -> Vector {
        delta(to: closest(on: line))
    }
    func delta(to segment: Segment) -> Vector {
        delta(to: closest(on: segment))
    }
    func delta(to polygon: Polygon) -> Vector {
        delta(to: closest(on: polygon))
    }
    func delta(to box: Box) -> Vector {
        delta(to: closest(on: box))
    }
    func delta(to circle: Circle) -> Vector {
        delta(to: closest(on: circle))
    }
    
    // ----- Conversions ----- //
    var vector: Vector {
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
    static func +(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x+rhs.x, y: lhs.y+rhs.y)
    }
    static func +=(lhs: inout Point, rhs: Point) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    static func +(lhs: Point, rhs: Vector) -> Point {
        Point(x: lhs.x+rhs.dx, y: lhs.y+rhs.dy)
    }
    static func +=(lhs: inout Point, rhs: Vector) {
        lhs.x += rhs.dx
        lhs.y += rhs.dy
    }
    static func +(lhs: Point, rhs: Double) -> Point {
        Point(x: lhs.x+rhs, y: lhs.y+rhs)
    }
    static func +=(lhs: inout Point, rhs: Double) {
        lhs.x += rhs
        lhs.y += rhs
    }
    static func -(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x-rhs.x, y: lhs.y-rhs.y)
    }
    static func -=(lhs: inout Point, rhs: Point) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
    static func -(lhs: Point, rhs: Vector) -> Point {
        Point(x: lhs.x-rhs.dx, y: lhs.y-rhs.dy)
    }
    static func -=(lhs: inout Point, rhs: Vector) {
        lhs.x -= rhs.dx
        lhs.y -= rhs.dy
    }
    static func -(lhs: Point, rhs: Double) -> Point {
        Point(x: lhs.x-rhs, y: lhs.y-rhs)
    }
    static func -=(lhs: inout Point, rhs: Double) {
        lhs.x -= rhs
        lhs.y -= rhs
    }
    static func *(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x*rhs.x, y: lhs.y*rhs.y)
    }
    static func *=(lhs: inout Point, rhs: Point) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
    }
    static func *(lhs: Point, rhs: Vector) -> Point {
        Point(x: lhs.x*rhs.dx, y: lhs.y*rhs.dy)
    }
    static func *=(lhs: inout Point, rhs: Vector) {
        lhs.x *= rhs.dx
        lhs.y *= rhs.dy
    }
    static func *(lhs: Point, rhs: Double) -> Point {
        Point(x: lhs.x*rhs, y: lhs.y*rhs)
    }
    static func *=(lhs: inout Point, rhs: Double) {
        lhs.x *= rhs
        lhs.y *= rhs
    }
    static func /(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x/rhs.x, y: lhs.y/rhs.y)
    }
    static func /=(lhs: inout Point, rhs: Point) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
    }
    static func /(lhs: Point, rhs: Vector) -> Point {
        Point(x: lhs.x/rhs.dx, y: lhs.y/rhs.dy)
    }
    static func /=(lhs: inout Point, rhs: Vector) {
        lhs.x /= rhs.dx
        lhs.y /= rhs.dy
    }
    static func /(lhs: Point, rhs: Double) -> Point {
        Point(x: lhs.x/rhs, y: lhs.y/rhs)
    }
    static func /=(lhs: inout Point, rhs: Double) {
        lhs.x /= rhs
        lhs.y /= rhs
    }

    static prefix func -(point: Point) -> Point {
        Point(x: -point.x, y: -point.y)
    }
    
    // ----- Conformance ----- //
    var description: String {
        "(x: \(x),   y: \(y))"
    }
    
    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.x = try container.decode(Double.self, forKey: .x)
        self.y = try container.decode(Double.self, forKey: .y)
    }
    static func == (lhs: Point, rhs: Point) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine("x\(x)y\(y)")
    }


    /* ----- TODO -----
        Codable
        Hashable
        Equatable
    */
}
