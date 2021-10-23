//
//  Polygon.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/22/21.
//

import Foundation
import Combine

@available(macOS 10.15, *)
class Polygon: CustomStringConvertible, Hashable, Codable {
    // MARK: - Statics
    class Vertex: CustomStringConvertible, Hashable, Codable {
        // MARK: - Indepenants
        let id = UUID()
        var position: Point
        var last: Vertex!
        var next: Vertex!
        
        
        // MARK: - Dependants
        var interior: Double {
            (position.delta(to: last.position).perpendicular.normal + next.position.delta(to: position).perpendicular.normal).normal.degrees.degreesSimplified
        }
        var exterior: Double {
            (last.position.delta(to: position).perpendicular.normal + position.delta(to: next.position).perpendicular.normal).normal.degrees.degreesSimplified
        }
        var tip: Bool {
            let ll = last.position.delta(to: position).perpendicular.normal
            let nl = position.delta(to: next.position).perpendicular.normal
            return ((ll.degrees - nl.degrees)).degreesSimplified > 180
        }
        var cave: Bool {
            !tip
        }
        
        // MARK: - Adjustments
        
        
        // MARK: - Testing
        
        
        // MARK: - Initializers
        init(position: Point, last: Vertex? = nil, next: Vertex? = nil) {
            self.position = position
            self.last = last
            self.next = next
        }
        init(_ vertex: Vertex) {
            self.position = vertex.position
            self.last = vertex.last
            self.next = vertex.next
        }
        
        
        // MARK: - Conformance
        // ----- CustomStringConvertible ----- //
        var description: String {
            "Vertex(position: \(position))"
        }
        // ----- Hashable ----- //
        static func == (lhs: Vertex, rhs: Vertex) -> Bool {
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
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        // ----- Codable ----- //
        private enum CodingKeys: String, CodingKey {
            case position
            case last
            case next
        }
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.position = try container.decode(Point.self, forKey: .position)
            self.next = try container.decode(Vertex.self, forKey: .next)
            self.last = try container.decode(Vertex.self, forKey: .last)
        }
        
        
        // MARK: - Operators
    }
    
    // MARK: - Indepenants
    let id = UUID()
    @Published var points: [Point]
    var observer: AnyCancellable = AnyCancellable {}
    
    
    
    // MARK: - Dependants
    var vertices: [Vertex] {
        var vertices: [Vertex] = []
        for point in points {
            vertices.append(Vertex(position: point))
        }
        for index in vertices.indices {
            vertices[index].last = vertices[index == 0 ? vertices.count-1 : index-1]
            vertices[index].next = vertices[index == vertices.count-1 ? 0 : index+1]
        }
        return vertices
    }
    var triangles: [Polygon] {
        var triangles: [Polygon] = []
        var left = vertices
        
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
        return triangles
    }
    
    
    // MARK: - Adjustments
    
    
    // MARK: - Testing
    
    
    // MARK: - Initializers
    init(points: [Point]) {
        self.points = points
        self.observer = $points
            .sink() { _ in
                print("changed: \(self.points.count)")
            }
    }
    init(_ polygon: Polygon) {
        self.points = polygon.points
        self.observer = $points
            .sink() { _ in
                print("changed: \(self.points.count)")
            }
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertible ----- //
    var description: String {
        "Polygon(points: \(points))"
    }
    // ----- Hashable ----- //
    static func == (lhs: Polygon, rhs: Polygon) -> Bool {
        lhs.points == rhs.points
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case points
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.points = try container.decode([Point].self, forKey: .points)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
    }
    
    
    // MARK: - Operators
}
