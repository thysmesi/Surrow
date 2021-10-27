//
//  File.swift
//
//
//  Created by Corbin Bigler on 10/27/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension Size {
    // ----- Point ----- //
    public static func +(lhs: Size, rhs: Point) -> Size {
        Size(lhs.width+rhs.x, lhs.height+rhs.y)
    }
    public static func +=(lhs: inout Size, rhs: Point) {
        lhs.width += rhs.x
        lhs.height += rhs.y
    }
    public static func -(lhs: Size, rhs: Point) -> Size {
        Size(lhs.width-rhs.x, lhs.height-rhs.y)
    }
    public static func -=(lhs: inout Size, rhs: Point) {
        lhs.width -= rhs.x
        lhs.height -= rhs.y
    }
    public static func *(lhs: Size, rhs: Point) -> Size {
        Size(lhs.width*rhs.x, lhs.height*rhs.y)
    }
    public static func *=(lhs: inout Size, rhs: Point) {
        lhs.width *= rhs.x
        lhs.height *= rhs.y
    }
    public static func /(lhs: Size, rhs: Point) -> Size {
        Size(lhs.width/rhs.x, lhs.height/rhs.y)
    }
    public static func /=(lhs: inout Size, rhs: Point) {
        lhs.width /= rhs.x
        lhs.height /= rhs.y
    }

    // ----- Vector ----- //
    public static func +(lhs: Size, rhs: Vector) -> Size {
        Size(lhs.width+rhs.dx, lhs.height+rhs.dy)
    }
    public static func +=(lhs: inout Size, rhs: Vector) {
        lhs.width += rhs.dx
        lhs.height += rhs.dy
    }
    public static func -(lhs: Size, rhs: Vector) -> Size {
        Size(lhs.width-rhs.dx, lhs.height-rhs.dy)
    }
    public static func -=(lhs: inout Size, rhs: Vector) {
        lhs.width -= rhs.dx
        lhs.height -= rhs.dy
    }
    public static func *(lhs: Size, rhs: Vector) -> Size {
        Size(lhs.width*rhs.dx, lhs.height*rhs.dy)
    }
    public static func *=(lhs: inout Size, rhs: Vector) {
        lhs.width *= rhs.dx
        lhs.height *= rhs.dy
    }
    public static func /(lhs: Size, rhs: Vector) -> Size {
        Size(lhs.width/rhs.dx, lhs.height/rhs.dy)
    }
    public static func /=(lhs: inout Size, rhs: Vector) {
        lhs.width /= rhs.dx
        lhs.height /= rhs.dy
    }

    // ----- Size ----- //
    public static func +(lhs: Size, rhs: Size) -> Size {
        Size(lhs.width+rhs.width, lhs.height+rhs.height)
    }
    public static func +=(lhs: inout Size, rhs: Size) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }
    public static func -(lhs: Size, rhs: Size) -> Size {
        Size(lhs.width-rhs.width, lhs.height-rhs.height)
    }
    public static func -=(lhs: inout Size, rhs: Size) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }
    public static func *(lhs: Size, rhs: Size) -> Size {
        Size(lhs.width*rhs.width, lhs.height*rhs.height)
    }
    public static func *=(lhs: inout Size, rhs: Size) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }
    public static func /(lhs: Size, rhs: Size) -> Size {
        Size(lhs.width/rhs.width, lhs.height/rhs.height)
    }
    public static func /=(lhs: inout Size, rhs: Size) {
        lhs.width /= rhs.width
        lhs.height /= rhs.height
    }

    // ----- Double ----- //
    public static func +(lhs: Size, rhs: Double) -> Size {
        Size(lhs.width+rhs, lhs.height+rhs)
    }
    public static func +=(lhs: inout Size, rhs: Double) {
        lhs.width += rhs
        lhs.height += rhs
    }
    public static func -(lhs: Size, rhs: Double) -> Size {
        Size(lhs.width-rhs, lhs.height-rhs)
    }
    public static func -=(lhs: inout Size, rhs: Double) {
        lhs.width -= rhs
        lhs.height -= rhs
    }
    public static func *(lhs: Size, rhs: Double) -> Size {
        Size(lhs.width*rhs, lhs.height*rhs)
    }
    public static func *=(lhs: inout Size, rhs: Double) {
        lhs.width *= rhs
        lhs.height *= rhs
    }
    public static func /(lhs: Size, rhs: Double) -> Size {
        Size(lhs.width/rhs, lhs.height/rhs)
    }
    public static func /=(lhs: inout Size, rhs: Double) {
        lhs.width /= rhs
        lhs.height /= rhs
    }
    static prefix func -(size: Size) -> Size {
        return Size(-size.width, -size.height)
    }
}
