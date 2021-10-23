//
//  Segment.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/23/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public class Segment: Line {
    // MARK: - Statics
    
    
    // MARK: - Indepenants
    
    
    // MARK: - Dependants
    public var line: Line { Line(p1: p1, p2: p2) }
    
    public var max: Vector { Vector(Swift.max(p1.x, p2.x), Swift.max(p1.y, p2.y)) }
    public var min: Vector { Vector(Swift.min(p1.x, p2.x), Swift.min(p1.y, p2.y)) }
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    public override func intercects(_ other: Line) -> Point? {
        super.intercects(self)
    }
    public override func intercects(_ segment: Segment) -> Point? {
        let intercect = line.intercects(segment)
        if let intercect = intercect, intercect.fluffy(on: self) {
            return intercect
        }
        return nil
    }
    public override func intercects(_ polygon: Polygon) -> [Point] {
        line.intercects(polygon).filter {$0.fluffy(on: self)}
    }
    
    
    
    // MARK: - Initializers
    public override init(p1: Point, p2: Point) {
        super.init(p1: p1, p2: p2)
    }
    public init(_ segment: Segment) {
        super.init(p1: segment.p1, p2: segment.p2)
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    public override var description: String {
        "Segment(p1: \(p1), p2: \(p2))"
    }
    // ----- Hashable ----- //
    // ----- Codable ----- //
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    
    // MARK: - Operators
}
