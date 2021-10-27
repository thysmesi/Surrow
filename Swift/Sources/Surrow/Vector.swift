//
//  Vector.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/22/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public struct Vector: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    public static var zero: Vector {
        Vector(0, 0)
    }
    public static var unit: Vector {
        Vector(1, 1)
    }
    
    // MARK: - Indepenants
    public let id = UUID()
    public var dx: Double
    public var dy: Double
    
    
    // MARK: - Dependants
    public var point: Point { Point(dx, dy) }
    public var size: Size { Size(dx, dy) }
    
    public var length: Double {
        abs(sqrt(pow(dx,2)+pow(dy,2)))
    }
    public var degrees: Double {
        atan2(dy, dx) / (Double.pi / 180)
    }
    public var normal: Vector {
        if(length == 0) {
            return Vector(Double.random(in: -1...1), Double.random(in: -1...1)).normal
        } else {
            return Vector(dx/length, dy/length)
        }
    }
    public var perpendicular: Vector {
        Vector(dy, -dx)
    }
    
    
    // MARK: - Adjustments
    public func cross(_ other: Vector) -> Double {
        dx * other.dy - dy * other.dx
    }
    public func dot(_ other: Vector) -> Double {
        dx * other.dx + dy * other.dy
    }
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    public init(_ dx: Double, _ dy: Double) {
        self.dx = dx
        self.dy = dy
    }
    public init(degrees: Double) {
        self.dx = cos(degrees.toRadians)
        self.dy = sin(degrees.toRadians)
    }
    public init(_ vector: Vector) {
        self.dx = vector.dx
        self.dy = vector.dy
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    public var description: String {
        "Vector(dx: \(dx), dy: \(dy))"
    }
    // ----- Hashable ----- //
    public static func == (lhs: Vector, rhs: Vector) -> Bool {
        lhs.dx == rhs.dx && lhs.dy == rhs.dy
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case dx
        case dy
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dx = try container.decode(Double.self, forKey: .dx)
        self.dy = try container.decode(Double.self, forKey: .dy)
    }
}
