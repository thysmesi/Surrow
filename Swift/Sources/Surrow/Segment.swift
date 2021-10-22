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
    var min: Point {
        Point(x: Swift.min(p1.x,p2.x), y: Swift.min(p1.y,p2.y))
    }
    var max: Point {
        Point(x: Swift.max(p1.x,p2.x), y: Swift.max(p1.y,p2.y))
    }
    var middle: Point {
        Point(x: (p2.x+p1.x)/2, y: (p2.y+p1.y)/2)
    }
    var xRange: ClosedRange<Double> {
        min.x...max.x
    }
    var yRange: ClosedRange<Double> {
        min.y...max.y
    }
    var bounding: Box {
        Box(position: middle, size: min.delta(to: max).size)
    }
    
    // ----- Initializers ----- //
    override init(p1: Point, p2: Point) {
        super.init(p1: p1, p2: p2)
    }
    
    // ----- Tests ----- //
    override func intercects(line: Line) -> Point? {
        line.intercects(segment: self)
    }
    override func intercects(segment: Segment) -> Point? {
        let intercect = intercects(line: segment.line)
        if let intercect = intercect {
            if intercect.within(box: segment.bounding) {
                return intercect
            }
        }
        return nil
    }
    override func intercects(polygon: Polygon) -> [Point] {
        var intercections: [Point] = []
        for segment in polygon.segments {
            if let intercect = intercects(segment: segment) {
                intercections.append(intercect)
            }
        }
        return intercections
    }
    override func intercects(box: Box) -> [Point] {
        intercects(polygon: box.polygon)
    }
    override func intercects(circle: Circle) -> [Point] {
        let intercections = super.intercects(circle: circle)
        return intercections.filter {$0.within(box: bounding)}
    }
    
    // ----- Conversions ----- //
    var line: Line {
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
