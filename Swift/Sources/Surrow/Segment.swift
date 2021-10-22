//
//  Segment.swift
//  Conquerors
//
//  Created by Corbin Bigler on 9/14/21.
//

import Foundation

public class Segment: Line, Decodable {
    // ----- Static ----- //
    
    // ----- Independent ----- //
    
    // ----- Dependent ----- //
    public var min: Point {
        Point(x: Swift.min(p1.x,p2.x), y: Swift.min(p1.y,p2.y))
    }
    public var max: Point {
        Point(x: Swift.max(p1.x,p2.x), y: Swift.max(p1.y,p2.y))
    }
    public var middle: Point {
        Point(x: (p2.x+p1.x)/2, y: (p2.y+p1.y)/2)
    }
    public var xRange: ClosedRange<Double> {
        min.x...max.x
    }
    public var yRange: ClosedRange<Double> {
        min.y...max.y
    }
    public var bounding: Box {
        Box(position: middle, size: min.delta(to: max).size)
    }
    
    // ----- Initializers ----- //
    public override init(p1: Point, p2: Point) {
        super.init(p1: p1, p2: p2)
    }
    
    // ----- Tests ----- //
    public override func intercects(line: Line) -> Point? {
        line.intercects(segment: self)
    }
    public override func intercects(segment: Segment) -> Point? {
        let intercect = intercects(line: segment.line)
        if let intercect = intercect {
            if intercect.on(segment) {
                return intercect
            }
        }
        return nil
    }
    public override func intercects(polygon: Polygon) -> [Point] {
        var intercections: [Point] = []
        for segment in polygon.segments {
            if let intercect = intercects(segment: segment) {
                intercections.append(intercect)
            }
        }
        return intercections
    }
    public override func intercects(box: Box) -> [Point] {
        intercects(polygon: box.polygon)
    }
    public override func intercects(circle: Circle) -> [Point] {
        let intercections = super.intercects(circle: circle)
        return intercections.filter {$0.within(bounding)}
    }
    
    // ----- Conversions ----- //
    public var line: Line {
        Line(p1: p1, p2: p2)
    }
    
    // ----- Operators ----- //
    
    // ----- Conformance ----- //
    /* ----- TODO -----
        Codable
        Hashable
        Equatable
        CustomStringConvertible    
    */
    private enum CodingKeys: String, CodingKey {
        case p1
        case p2
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        super.init(p1: try container.decode(Point.self, forKey: .p1), p2: try container.decode(Point.self, forKey: .p2))
    }
}
