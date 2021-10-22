//
//  Size.swift
//  Collision
//
//  Created by App Dev on 9/13/21.
//

import Foundation

public class Size {
    // ----- Static ----- //
    public static var zero: Size {
        Size(width: 0, height: 0)
    }
    
    // ----- Independent ----- //
    public var width: Double
    public var height: Double
    
    // ----- Dependent ----- //
    public var hWidth: Double {
        width / 2
    }
    public var hHeight: Double {
        height / 2
    }
    
    // ----- Initializers ----- //
    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    // ----- Tests ----- //
    
    // ----- Operators ----- //
    /* ----- TODO -----
        size + = Float
        size - = Float
        size * = Float
        size / = Float
    */
    public static func *(lhs: Size, rhs: Double) -> Size {
        Size(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    // ----- Conformance ----- //
    /* ----- TODO -----
        Codable
        Hashable
        Equatable
        CustomStringConvertible
    */
}
