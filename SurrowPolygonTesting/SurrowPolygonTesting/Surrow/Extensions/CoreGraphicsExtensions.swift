//
//  File.swift
//  
//
//  Created by Corbin Bigler on 10/23/21.
//

import CoreGraphics

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension CGSize {
    init(_ size: Size) {
        self.init(width: size.width, height: size.height)
    }
}
@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension Size {
    init(_ cg: CGSize) {
        self.init(cg.width, cg.height)
    }
}
