//
//  File.swift
//
//
//  Created by Corbin Bigler on 10/27/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension Point {
    // ----- Point ----- //
    public static func +(lhs: Point, rhs: Point) -> Point {
        Point(lhs.x+rhs.x, lhs.y+rhs.y)
    }
    public static func +=(lhs: inout Point, rhs: Point) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    public static func -(lhs: Point, rhs: Point) -> Point {
        Point(lhs.x-rhs.x, lhs.y-rhs.y)
    }
    public static func -=(lhs: inout Point, rhs: Point) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
    public static func *(lhs: Point, rhs: Point) -> Point {
        Point(lhs.x*rhs.x, lhs.y*rhs.y)
    }
    public static func *=(lhs: inout Point, rhs: Point) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
    }
    public static func /(lhs: Point, rhs: Point) -> Point {
        Point(lhs.x/rhs.x, lhs.y/rhs.y)
    }
    public static func /=(lhs: inout Point, rhs: Point) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
    }
    static prefix func -(point: Point) -> Point {
        return Point(-point.x, -point.y)
    }

    // ----- Vector ----- //
    public static func +(lhs: Point, rhs: Vector) -> Point {
        Point(lhs.x+rhs.dx, lhs.y+rhs.dy)
    }
    public static func +=(lhs: inout Point, rhs: Vector) {
        lhs.x += rhs.dx
        lhs.y += rhs.dy
    }
    public static func -(lhs: Point, rhs: Vector) -> Point {
        Point(lhs.x-rhs.dx, lhs.y-rhs.dy)
    }
    public static func -=(lhs: inout Point, rhs: Vector) {
        lhs.x -= rhs.dx
        lhs.y -= rhs.dy
    }
    public static func *(lhs: Point, rhs: Vector) -> Point {
        Point(lhs.x*rhs.dx, lhs.y*rhs.dy)
    }
    public static func *=(lhs: inout Point, rhs: Vector) {
        lhs.x *= rhs.dx
        lhs.y *= rhs.dy
    }
    public static func /(lhs: Point, rhs: Vector) -> Point {
        Point(lhs.x/rhs.dx, lhs.y/rhs.dy)
    }
    public static func /=(lhs: inout Point, rhs: Vector) {
        lhs.x /= rhs.dx
        lhs.y /= rhs.dy
    }

    // ----- Size ----- //
    public static func +(lhs: Point, rhs: Size) -> Point {
        Point(lhs.x+rhs.width, lhs.y+rhs.height)
    }
    public static func +=(lhs: inout Point, rhs: Size) {
        lhs.x += rhs.width
        lhs.y += rhs.height
    }
    public static func -(lhs: Point, rhs: Size) -> Point {
        Point(lhs.x-rhs.width, lhs.y-rhs.height)
    }
    public static func -=(lhs: inout Point, rhs: Size) {
        lhs.x -= rhs.width
        lhs.y -= rhs.height
    }
    public static func *(lhs: Point, rhs: Size) -> Point {
        Point(lhs.x*rhs.width, lhs.y*rhs.height)
    }
    public static func *=(lhs: inout Point, rhs: Size) {
        lhs.x *= rhs.width
        lhs.y *= rhs.height
    }
    public static func /(lhs: Point, rhs: Size) -> Point {
        Point(lhs.x/rhs.width, lhs.y/rhs.height)
    }
    public static func /=(lhs: inout Point, rhs: Size) {
        lhs.x /= rhs.width
        lhs.y /= rhs.height
    }

    // ----- Double ----- //
    public static func +(lhs: Point, rhs: Double) -> Point {
        Point(lhs.x+rhs, lhs.y+rhs)
    }
    public static func +=(lhs: inout Point, rhs: Double) {
        lhs.x += rhs
        lhs.y += rhs
    }
    public static func -(lhs: Point, rhs: Double) -> Point {
        Point(lhs.x-rhs, lhs.y-rhs)
    }
    public static func -=(lhs: inout Point, rhs: Double) {
        lhs.x -= rhs
        lhs.y -= rhs
    }
    public static func *(lhs: Point, rhs: Double) -> Point {
        Point(lhs.x*rhs, lhs.y*rhs)
    }
    public static func *=(lhs: inout Point, rhs: Double) {
        lhs.x *= rhs
        lhs.y *= rhs
    }
    public static func /(lhs: Point, rhs: Double) -> Point {
        Point(lhs.x/rhs, lhs.y/rhs)
    }
    public static func /=(lhs: inout Point, rhs: Double) {
        lhs.x /= rhs
        lhs.y /= rhs
    }
}
