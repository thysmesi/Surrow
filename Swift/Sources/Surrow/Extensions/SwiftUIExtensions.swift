//
//  Extensions.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/23/21.
//

import SwiftUI

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension CGPoint {
    init(_ point: Point) {
        self.init(x: point.x, y: point.y)
    }
}
@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension CGVector {
    init(_ vector: Vector) {
        self.init(dx: vector.dx, dy: vector.dy)
    }
}
@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension Path {
    mutating func move(to point: Point) {
        move(to: CGPoint(point))
    }
    mutating func addLine(to point: Point) {
        addLine(to: CGPoint(point))
    }
}
@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension View {
    func position(_ point: Point) -> some View {
        position(x: point.x, y: point.y)
    }
}
