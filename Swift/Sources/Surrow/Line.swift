//
//  Line.swift
//  Conquerors
//
//  Created by Corbin Bigler on 9/14/21.
//

import Foundation
import SwiftUI

public class Line {
    // ----- Static ----- //
    
    // ----- Independent ----- //
    var p1: Point
    var p2: Point
    
    // ----- Dependent ----- //
    var slope: Double {
        (p2.y - p1.y) / (p2.x - p1.x)
    }
    var perpendicular: Double {
        1 / -slope
    }
    var yIntercept: Double {
        y(0)
    }
    var xIntercept: Double {
        x(0)
    }
    
    // ----- Initializers ----- //
    init(p1: Point, p2: Point) {
        self.p1 = p1
        self.p2 = p2
    }
    init(slope: Double, point: Point) {
        self.p1 = point
        self.p2 = Point(x: point.x + 1, y: point.y + slope)
    }
    init(slope: Double, yIntercept: Double) {
        self.p1 = Point(x: 0, y: yIntercept)
        self.p2 = Point(x: 1, y: slope + yIntercept)
    }
    
    // ----- Tests ----- //
    func y(_ x: Double) -> Double {
        (slope*x) - (slope*p1.x) + p1.y
    }
    func x(_ y: Double) -> Double {
        (y/slope) - (p1.y/slope) + p1.x
    }

    func intercects(segment: Segment) -> Point?{
        let intercect = intercects(line: segment.line)
        if let intercect = intercect {
            if intercect.within(box: segment.bounding) {
                return intercect
            }
        }
        return nil
    }
    func intercects(line other: Line) -> Point?{
        
        if slope == other.slope {
            return nil
        }
    
        if yIntercept.isNaN {
            return Point(x: p1.x, y: other.y(p1.x))
        }
        if other.yIntercept.isNaN {
            return Point(x: other.p1.x, y: y(other.p1.x))
        }
        
        let x = (other.yIntercept - yIntercept) / (slope - other.slope)
        let y = slope * x + yIntercept
        
        return Point(x: x, y: y)
    }
    func intercects(polygon: Polygon) -> [Point] {
        var intercections: [Point] = []
        for segment in polygon.segments {
            if let intercect = intercects(segment: segment) {
                intercections.append(intercect)
            }
        }
        return intercections
    }
    func intercects(box: Box) -> [Point] {
        intercects(polygon: box.polygon)
    }
    func intercects(circle: Circle) -> [Point] {
        let aprim = (1 + pow(slope,2))
        let bprim = 2 * slope * (yIntercept - circle.position.y) - 2 * circle.position.x
        let cprim = pow(circle.position.x,2) + pow((yIntercept - circle.position.y),2) - pow(circle.radius, 2)
        
        let delta = pow(bprim, 2) - 4 * aprim * cprim
        
        let x1 = (-bprim + sqrt(delta)) / (2 * aprim)
        let x2 = (-bprim - sqrt(delta)) / (2 * aprim)
        
        var intercections: [Point] = []
        if x1.isFinite {
            intercections.append(Point(x: x1, y: y(x1)))
        }
        if x2.isFinite {
            intercections.append(Point(x: x2, y: y(x2)))
        }
        return intercections
    }
    
    // ----- Operators ----- //
    /* ----- TODO -----
        Line + = Point
        Line + = Vector
        Line + = Float
        Line - = Point
        Line - = Vector
        Line - = Float
        Line * = Point
        Line * = Vector
        Line * = Float
        Line / = Point
        Line / = Vector
        Line / = Float
    */
    
    // ----- Conformance ----- //
    /* ----- TODO -----
        Codable
        Hashable
        Equatable
        CustomStringConvertible
    */
}
