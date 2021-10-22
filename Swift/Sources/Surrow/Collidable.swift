//
//  Collidable.swift
//  Collision
//
//  Created by Corbin Bigler on 9/29/21.
//

import Foundation

public protocol Collidable {
    var position: Point { get set }
    var bounding: Box { get }
    
    func collides(with collidable: Collidable) -> Vector?
    func collides(with box: Box) -> Vector?
    func collides(with circle: Circle) -> Vector?
    func collides(with polygon: Polygon) -> Vector?
    func collides(with segment: Segment) -> Vector?
}
