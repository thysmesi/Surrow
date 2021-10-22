//
//  Size.swift
//  Collision
//
//  Created by App Dev on 9/13/21.
//

import Foundation

class Size {
    // ----- Static ----- //
    static var zero: Size {
        Size(width: 0, height: 0)
    }
    
    // ----- Independent ----- //
    var width: Double
    var height: Double
    
    // ----- Dependent ----- //
    var hWidth: Double {
        width / 2
    }
    var hHeight: Double {
        height / 2
    }
    
    // ----- Initializers ----- //
    init(width: Double, height: Double) {
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
    static func *(lhs: Size, rhs: Double) -> Size {
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
