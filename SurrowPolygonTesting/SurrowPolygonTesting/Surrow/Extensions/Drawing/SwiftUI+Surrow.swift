//
//  SwiftUI+Surrow-Drawing.swift
//  SurrowPolygonTesting
//
//  Created by Corbin Bigler on 11/17/21.
//

import SwiftUI

func PolygonPath(polygon: Polygon) -> Path {
    Path { path in
        path.move(to: polygon.vertices[0].position)
        for vertex in polygon.vertices {
            path.addLine(to: vertex.next.position)
        }
    }
}

extension View {
    func position(point: Point) -> some View {
        self.position(x: point.x, y: point.y)
    }
    func frame(size: Size) -> some View {
        self.frame(width: size.width, height: size.height)
    }
}

extension Point {
    init(_ cg: CGPoint) {
        self.x = cg.x
        self.y = cg.y
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
