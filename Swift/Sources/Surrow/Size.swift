//
//  Size.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/22/21.
//

import Foundation

class Size: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    static var zero: Size {
        Size(0, 0)
    }
    static var unit: Size {
        Size(1, 1)
    }
    
    // MARK: - Indepenants
    let id = UUID()
    var width: Double
    var height: Double
    
    
    // MARK: - Dependants
    var point: Point { Point(width, height) }
    var vector: Vector { Vector(width, height) }
    
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    init(_ width: Double, _ height: Double) {
        self.width = width
        self.height = height
    }
    init(_ size: Size) {
        self.width = size.width
        self.height = size.height
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    var description: String {
        "Size(width: \(width), height: \(height))"
    }
    // ----- Hashable ----- //
    static func == (lhs: Size, rhs: Size) -> Bool {
        lhs.width == rhs.width && lhs.height == rhs.height
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case width
        case height
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.width = try container.decode(Double.self, forKey: .width)
        self.height = try container.decode(Double.self, forKey: .height)
    }
    
    
    // MARK: - Operators
}
