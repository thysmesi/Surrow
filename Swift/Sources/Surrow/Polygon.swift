//
//  Polygon.swift
//  Conquerors
//
//  Created by App Dev on 9/14/21.
//

import Foundation

public class Polygon {
    // ----- Independent ----- //
    public var relatives: [Point]
    public var position: Point
    
    // ----- Dependent ----- //
    public var min: Point {
        var current = points[0]
        for point in points {
            current = Point(x: Swift.min(current.x, point.x), y: Swift.min(current.y, point.y))
        }
        return current
    }
    public var max: Point {
        var current = points[0]
        for point in points {
            current = Point(x: Swift.max(current.x, point.x), y: Swift.max(current.y, point.y))
        }
        return current
    }
    public var points: [Point] {
        var output: [Point] = []
        for point in relatives {
            output.append(point + position)
        }
        return output
    }
    public var normals: [Vector] {
        var output: [Vector] = []
        for index in 0..<edges.count {
            output.append(edges[index].perpendicular.normal)
        }
        return output
    }
    public var edges: [Vector] {
        var output: [Vector] = []
        for index in 0..<relatives.count {
            let p1 = relatives[index]
            let p2 = index < relatives.count - 1 ? relatives[index + 1] : relatives[0]

            output.append(p1.delta(to: p2))
        }
        return output
    }
    public var segments: [Segment] {
        var output: [Segment] = []
        for index in 0..<points.count {
            output.append(Segment(
                p1: points[index],
                p2: index == points.count-1 ? points[0] : points[index+1]
            ))
        }
        return output
    }
    public var bounding: Box {
        let width = max.x - min.x
        let height = max.y - min.y
        return Box(position: Point(x: max.x - (width/2), y: max.y - (height / 2)), size: Size(width: width, height: height))
    }
    public var middle: Point {
        var sum = Point.origin
        for point in points {
            sum += point
        }
        return sum / Double(points.count)
    }
    
    public var convex: Bool {
        // ----- Souce: https://stackoverflow.com/questions/471962/how-do-i-efficiently-determine-if-a-polygon-is-convex-non-convex-or-complex ----- //
        if normals.count < 4 {
            return true
        }
        
        var sign = false
        let count = relatives.count
        for index in 0..<count {
            let d1 = Vector(
                dx: relatives[(index + 2) % count].x - relatives[(index + 1) % count].x,
                dy: relatives[(index + 2) % count].y - relatives[(index + 1) % count].y
            )
            let d2 = Vector(
                dx: relatives[index].x - relatives[(index + 1) % count].x,
                dy: relatives[index].y - relatives[(index + 1) % count].y
            )
            let zcross = d1.cross(d2)
            
            if index == 0 {
                sign = zcross > 0
            } else if sign != (zcross > 0) {
                return false
            }
        }
        return false
    }
    
    
    // ----- Initializers ----- //
    public init(relatives: [Point], position: Point) {
        self.relatives = relatives
        self.position = position
    }
    public init(points: [Point]) {
        self.relatives = points
        self.position = Point.origin
    }
    
    // ----- Tests ----- //
    public func rotated(degrees: Double) -> Polygon {
        Polygon(relatives: relatives.map {$0.rotated(around: Point.origin, degrees: degrees)}, position: position)
    }
    public func collides(with segment: Segment) -> Vector? {
        var greater: [Vector] = []
        var lesser: [Vector] = []
        
        var tests: Set<Point> = []
        for side in segments {
            if let _ = side.intercects(segment: segment) {
                tests.insert(side.p1)
                tests.insert(side.p2)
            }
        }
        for point in tests {
            if ((point.x-segment.p1.x)*(segment.p2.y-segment.p1.y)) - ((point.y - segment.p1.y)*(segment.p2.x-segment.p1.x)) > 0 {
                greater.append(point.delta(to: point.closest(on: segment)))
            } else {
                lesser.append(point.delta(to: point.closest(on: segment)))
            }
        }
        
        var greaterSum: Double = 0
        for vector in greater {
            greaterSum += vector.length
        }
        var lesserSum: Double = 0
        for vector in lesser {
            lesserSum += vector.length
        }
        
        var largest: Vector? = nil
        for vector in (greaterSum > lesserSum ? lesser : greater) {
            if largest == nil || vector.length > largest!.length {
                largest = vector
            }
        }
        
        return largest
    }
    public func collides(with box: Box) -> Vector? {
        return collides(with: box.polygon)
    }

    public func collides(with circle: Circle) -> Vector? {
        let vector = circle.collides(with: self)
        return vector == nil ? nil : -vector!
    }

    public func collides(with polygon: Polygon) -> Vector? {
        if convex && polygon.convex && false {

        } else {
            var within: [Point] = []
            for point in points {
                if point.within(polygon) {
                    within.append(point)
                }
            }
            var aIntercecting: [Segment] = []
            var bIntercecting: [Segment] = []
            for a in segments {
                for b in polygon.segments {
                    if let _ = a.intercects(segment: b) {
                        aIntercecting.append(a)
                        bIntercecting.append(b)
                    }
                }
            }
            var smallest: Vector? = nil
            for point in within {
                var smallestToSegment: Vector? = nil
                for segment in bIntercecting {
                    let vector = point.delta(to: segment)
                    if smallestToSegment == nil || vector.length < smallestToSegment!.length {
                        smallestToSegment = vector
                    }
                }
                if smallest == nil || smallestToSegment!.length < smallest!.length {
                    smallest = smallestToSegment
                }
            }
                         
            if let smallest = smallest {
                 return smallest
            }
            
            within = []
            for point in polygon.points{
                if point.within(self) {
                    within.append(point)
                }
            }
            smallest = nil
            for point in within {
                var smallestToSegment: Vector? = nil
                for segment in aIntercecting {
                    let vector = point.delta(to: segment)
                    if smallestToSegment == nil || vector.length < smallestToSegment!.length {
                        smallestToSegment = vector
                    }
                }
                if smallest == nil || smallestToSegment!.length < smallest!.length {
                    smallest = smallestToSegment
                }
            }
            
            if let smallest = smallest {
                 return -smallest
            }
        }
        return nil
    }
    
    // ----- Operators ----- //
    /* ----- TODO -----
        Polygon * = Float
        Polygon / = Float
    */
    public static func *(lhs: Polygon, rhs: Double) -> Polygon {
        Polygon(relatives: lhs.relatives.map {$0 * rhs} , position: lhs.position)
    }
    public static func *=(lhs: inout Polygon, rhs: Double) {
        lhs.relatives = lhs.relatives.map {$0 * rhs}
    }
    
    // ----- Conformance ----- //
    /* ----- TODO -----
        Codable
        Hashable
        Equatable
        CustomStringConvertible
    */
}
