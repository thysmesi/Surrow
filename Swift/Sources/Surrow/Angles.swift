//
//  Degrees.swift
//  PolygonMaster
//
//  Created by Corbin Bigler on 10/23/21.
//

import Foundation

public let π = Double.pi

public extension Double {
    var toDegrees: Double {
        self * (180 / π)
    }
    var toRadians: Double {
        self * (π / 180)
    }
    
    var degreesSimplified: Double {
        (self.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
    }
}
