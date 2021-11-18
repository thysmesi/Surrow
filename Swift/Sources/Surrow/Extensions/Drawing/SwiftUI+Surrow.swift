//
//  SwiftUI+Surrow-Drawing.swift
//  SurrowPolygonTesting
//
//  Created by Corbin Bigler on 11/17/21.
//

import SwiftUI

@available(iOS 13.0, *)
@available(macOS 10.15, *)
func PolygonPath(polygon: Polygon) -> Path {
    Path { path in
        path.move(to: polygon.vertices[0].position)
        for vertex in polygon.vertices {
            path.addLine(to: vertex.next.position)
        }
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension View {
    func position(point: Point) -> some View {
        self.position(x: point.x, y: point.y)
    }
    func frame(size: Size) -> some View {
        self.frame(width: size.width, height: size.height)
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension Point {
    init(_ cg: CGPoint) {
        self.x = cg.x
        self.y = cg.y
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension CGPoint {
    init(_ point: Point) {
        self.init(x: point.x, y: point.y)
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension CGVector {
    init(_ vector: Vector) {
        self.init(dx: vector.dx, dy: vector.dy)
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension Path {
    mutating func move(to point: Point) {
        move(to: CGPoint(point))
    }
    mutating func addLine(to point: Point) {
        addLine(to: CGPoint(point))
    }
}
