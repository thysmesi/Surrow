//
//  Line.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/23/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public class Line: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    
    
    // MARK: - Indepenants
    public let id = UUID()
    public var p1: Point
    public var p2: Point
    
    
    // MARK: - Dependants
    public var slope: Double {
        (p2.y - p1.y) / (p2.x - p1.x)
    }
    public var perpendicular: Double {
        1 / -slope
    }
    public var yIntercept: Double {
        y(0)
    }
    public var xIntercept: Double {
        x(0)
    }
    
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    public func y(_ x: Double) -> Double {
        (slope*x) - (slope*p1.x) + p1.y
    }
    public func x(_ y: Double) -> Double {
        (y/slope) - (p1.y/slope) + p1.x
    }
    
    public func intercects(_ other: Line) -> Point?{
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
    public func intercects(_ segment: Segment) -> Point?{
        let intercect = intercects(segment.line)
        if let intercect = intercect, intercect.fluffy(on: segment) {
            return intercect
        }
        return nil
    }
    public func intercects(_ polygon: Polygon) -> [Point] {
        var output: [Point] = []
        for segment in polygon.sides {
            if let intercect = intercects(segment) {
                output.append(intercect)
            }
        }
        return output
    }
    
    // MARK: - Initializers
    public init(p1: Point, p2: Point) {
        self.p1 = p1
        self.p2 = p2
    }
    public init(slope: Double, point: Point) {
        self.p1 = point
        self.p2 = Point(point.x + 1, point.y + slope)
    }
    public init(slope: Double, yIntercept: Double) {
        self.p1 = Point(0, yIntercept)
        self.p2 = Point(1, slope + yIntercept)
    }
    public init(_ line: Line) {
        self.p1 = line.p1
        self.p2 = line.p2
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    public var description: String {
        "Line(p1: \(p1), p2: \(p2))"
    }
    // ----- Hashable ----- //
    public static func == (lhs: Line, rhs: Line) -> Bool {
        lhs.p1 == rhs.p1 && lhs.p2 == rhs.p2
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case p1
        case p2
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.p1 = try container.decode(Point.self, forKey: .p1)
        self.p2 = try container.decode(Point.self, forKey: .p2)
    }
    
    
    // MARK: - Operators
}
