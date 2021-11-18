//
//  SwiftUI+Surrow-Drawing.swift
//  SurrowPolygonTesting
//
//  Created by Corbin Bigler on 11/17/21.
//

import SwiftUI

struct PolygonShape: Shape {
    let polygon: Polygon

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: polygon.vertices[0].position)
            for vertex in polygon.vertices {
                path.addLine(to: vertex.next.position)
            }
        }
    }
}

extension CGPoint {
    init(_ point: Point) {
        self.init(x: point.x, y: point.y)
    }
}

extension CGVector {
    init(_ vector: Vector) {
        self.init(dx: vector.dx, dy: vector.dy)
    }
}

extension Path {
    mutating func move(to point: Point) {
        move(to: CGPoint(point))
    }
    mutating func addLine(to point: Point) {
        addLine(to: CGPoint(point))
    }
}

extension View {
    func position(_ point: Point) -> some View {
        position(x: point.x, y: point.y)
    }
}

