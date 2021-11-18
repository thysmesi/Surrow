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
    
    func degreesDelta(to degrees: Double) -> Double{
        let diff = ( degrees - self + 180 ).truncatingRemainder(dividingBy: 360) - 180
        return diff < -180 ? diff + 360 : diff;
    }
}
