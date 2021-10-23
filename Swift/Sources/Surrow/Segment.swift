//
//  Segment.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/23/21.
//

import Foundation

@available(macOS 10.15, *)
class Segment: Line {
    // MARK: - Statics
    
    
    // MARK: - Indepenants
    
    
    // MARK: - Dependants
    var line: Line { Line(p1: p1, p2: p2) }
    
    var max: Vector { Vector(Swift.max(p1.x, p2.x), Swift.max(p1.y, p2.y)) }
    var min: Vector { Vector(Swift.min(p1.x, p2.x), Swift.min(p1.y, p2.y)) }
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    init(_ segment: Segment) {
        super.init(p1: segment.p1, p2: segment.p2)
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    override var description: String {
        "Segment(p1: \(p1), p2: \(p2))"
    }
    // ----- Hashable ----- //
    // ----- Codable ----- //
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    
    // MARK: - Operators
}
