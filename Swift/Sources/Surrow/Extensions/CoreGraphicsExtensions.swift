//
//  File.swift
//  
//
//  Created by Corbin Bigler on 10/23/21.
//

import CoreGraphics

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension CGSize {
    init(_ size: Size) {
        self.init(width: size.width, height: size.height)
    }
}
