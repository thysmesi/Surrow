//
//  File.swift
//  
//
//  Created by Corbin Bigler on 11/3/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension Segment {
    public static func +(lhs: Segment, rhs: Double) -> Segment {
        Segment(p1: lhs.p1+rhs, p2: lhs.p2+rhs)
    }
}
