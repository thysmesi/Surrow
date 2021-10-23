//
//  Line.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/23/21.
//

import Foundation

class Line: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    
    
    // MARK: - Indepenants
    let id = UUID()
    var p1: Point
    var p2: Point
    
    
    // MARK: - Dependants
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
    
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    func y(_ x: Double) -> Double {
        (slope*x) - (slope*p1.x) + p1.y
    }
    func x(_ y: Double) -> Double {
        (y/slope) - (p1.y/slope) + p1.x
    }
    
    func intercects(line other: Line) -> Point?{
        if slope == other.slope {
            return nil
        }
    
        if yIntercept.isNaN {
            return Point(p1.x, other.y(p1.x))
        }
        if other.yIntercept.isNaN {
            return Point(other.p1.x, y(other.p1.x))
        }
        
        let x = (other.yIntercept - yIntercept) / (slope - other.slope)
        let y = slope * x + yIntercept
        
        return Point(x, y)
    }
    
    
    // MARK: - Initializers
    init(p1: Point, p2: Point) {
        self.p1 = p1
        self.p2 = p2
    }
    init(slope: Double, point: Point) {
        self.p1 = point
        self.p2 = Point(point.x + 1, point.y + slope)
    }
    init(slope: Double, yIntercept: Double) {
        self.p1 = Point(0, yIntercept)
        self.p2 = Point(1, slope + yIntercept)
    }
    init(_ line: Line) {
        self.p1 = line.p1
        self.p2 = line.p2
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    var description: String {
        "Line(p1: \(p1), p2: \(p2))"
    }
    // ----- Hashable ----- //
    static func == (lhs: Line, rhs: Line) -> Bool {
        lhs.p1 == rhs.p1 && lhs.p2 == rhs.p2
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case p1
        case p2
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.p1 = try container.decode(Point.self, forKey: .p1)
        self.p2 = try container.decode(Point.self, forKey: .p2)
    }
    
    
    // MARK: - Operators
}
