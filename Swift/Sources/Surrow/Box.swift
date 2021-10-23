//
//  Box.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/22/21.
//

import Foundation

class Box: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    static var zero: Box {
        Box(position: Point.origin, size: Size.zero)
    }
    static var unit: Box {
        Box(position: Point.origin, size: Size.unit)
    }
    
    // MARK: - Indepenants
    let id = UUID()
    var position: Point
    var size: Size
    
    
    // MARK: - Dependants
    var left: Double { position.x }
    var right: Double { position.x + size.width }
    var top: Double { position.y }
    var bottom: Double { position.y + size.height}
    
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    init(position: Point, size: Size) {
        self.position = position
        self.size = size
    }
    init(_ box: Box) {
        self.position = box.position
        self.size = box.size
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    var description: String {
        "Box(position: \(position), size: \(size))"
    }
    // ----- Hashable ----- //
    static func == (lhs: Box, rhs: Box) -> Bool {
        lhs.position == rhs.position && lhs.size == rhs.size
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case position
        case size
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.position = try container.decode(Point.self, forKey: .position)
        self.size = try container.decode(Size.self, forKey: .size)
    }
    
    
    // MARK: - Operators
}
