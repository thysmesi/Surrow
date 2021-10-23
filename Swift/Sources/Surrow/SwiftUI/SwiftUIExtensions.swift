//
//  Extensions.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/23/21.
//

import SwiftUI

extension CGPoint {
    init(_ point: Point) {
        self.init(x: point.x, y: point.y)
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
