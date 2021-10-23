//
//  Polygon.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/22/21.
//

import Foundation
import Combine

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public class Polygon: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    public class Vertex: CustomStringConvertible, Hashable, Codable {
        // MARK: - Indepenants
        public let id = UUID()
        public var position: Point
        public var last: Vertex!
        public var next: Vertex!
        
        
        // MARK: - Dependants
        public var interior: Double {
            (position.delta(to: last.position).perpendicular.normal + next.position.delta(to: position).perpendicular.normal).normal.degrees.degreesSimplified
        }
        public var exterior: Double {
            (last.position.delta(to: position).perpendicular.normal + position.delta(to: next.position).perpendicular.normal).normal.degrees.degreesSimplified
        }
        public var tip: Bool {
            let ll = last.position.delta(to: position).perpendicular.normal
            let nl = position.delta(to: next.position).perpendicular.normal
            return ((ll.degrees - nl.degrees)).degreesSimplified > 180
        }
        public var cave: Bool {
            !tip
        }
        
        // MARK: - Adjustments
        
        
        // MARK: - Testing
        
        
        // MARK: - Initializers
        public init(position: Point, last: Vertex? = nil, next: Vertex? = nil) {
            self.position = position
            self.last = last
            self.next = next
        }
        public init(_ vertex: Vertex) {
            self.position = vertex.position
            self.last = vertex.last
            self.next = vertex.next
        }
        
        
        // MARK: - Conformance
        // ----- CustomStringConvertible ----- //
        public var description: String {
            "Vertex(position: \(position))"
        }
        // ----- Hashable ----- //
        public static func == (lhs: Vertex, rhs: Vertex) -> Bool {
            let cpos = lhs.position == rhs.position
            var clast = false
            var cnext = false
            if let ll = lhs.last, let rl = rhs.last {
                clast = ll.id == rl.id
            } else {
                clast = lhs.last == nil && rhs.last == nil
            }
            if let ln = lhs.next, let rn = rhs.next {
                cnext = ln.id == rn.id
            } else {
                cnext = lhs.next == nil && rhs.next == nil
            }
            return cpos && clast && cnext
        }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        // ----- Codable ----- //
        private enum CodingKeys: String, CodingKey {
            case position
            case last
            case next
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.position = try container.decode(Point.self, forKey: .position)
            self.next = try container.decode(Vertex.self, forKey: .next)
            self.last = try container.decode(Vertex.self, forKey: .last)
        }
        
        
        // MARK: - Operators
    }
    
    // MARK: - Indepenants
    public let id = UUID()
    @Published public var points: [Point]
    
    
    // MARK: - Dependants
    public var vertices: [Vertex] {
        if _vertices == nil {
            var vertices: [Vertex] = []
            for point in points {
                vertices.append(Vertex(position: point))
            }
            for index in vertices.indices {
                vertices[index].last = vertices[index == 0 ? vertices.count-1 : index-1]
                vertices[index].next = vertices[index == vertices.count-1 ? 0 : index+1]
            }
            _vertices = vertices
        }
        return _vertices!
    }
    private var _vertices: [Vertex]? = nil
    
    public var triangles: [Polygon] {
        if _triangles == nil {
            var triangles: [Polygon] = []
            var left = vertices.map { Vertex($0) }
            for index in left.indices {
                left[index].last = left[index == 0 ? left.count-1 : index-1]
                left[index].next = left[index == left.count-1 ? 0 : index+1]
            }

            while left.count > 3 {
                for index in left.indices {
                    let vertex = left[index]
                    if vertex.tip {
                        triangles.append(Polygon(points: [vertex.last.position, vertex.position, vertex.next.position]))
                        vertex.last.next = vertex.next
                        vertex.next.last = vertex.last
                        left.remove(at: index)
                        let removed = left.removeFirst()
                        left.append(removed)
                        break
                    }
                }
            }
            triangles.append(Polygon(points: [left[0].position, left[1].position, left[2].position]))
            _triangles = triangles
        }
        return _triangles!
    }
    private var _triangles: [Polygon]?
    
    public var sides: [Segment] {
        if _sides == nil {
            var segments: [Segment] = []
            for vertex in vertices {
                segments.append(Segment(p1: vertex.position, p2: vertex.next.position))
            }
            _sides = segments
        }
        return _sides!
    }
    private var _sides: [Segment]? = nil
    
    public var center: Point {
        if _center == nil {
            var sum = Point.origin
            for point in points {
                sum += point
            }
            _center = sum / Double(points.count)
        }
        return _center!
    }
    private var _center: Point? = nil
    
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    public init(points: [Point]) {
        self.points = points
        createObserver()
    }
    public init(_ polygon: Polygon) {
        self.points = polygon.points
        createObserver()
    }
    private func createObserver(){
        _ = $points
            .sink() { [self] _ in
                _vertices = nil
                _triangles = nil
            }
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    public var description: String {
        "Polygon(points: \(points))"
    }
    // ----- Hashable ----- //
    public static func == (lhs: Polygon, rhs: Polygon) -> Bool {
        lhs.points == rhs.points
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case points
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.points = try container.decode([Point].self, forKey: .points)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
    }
    
    
    // MARK: - Operators
}
