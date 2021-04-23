package com.example.surrow.surrow

import kotlin.math.cos
import kotlin.math.sin
import kotlin.math.sqrt


data class Point(var x: Float, var y: Float){
    operator fun plus(other: Point): Point {
        return Point(x + other.x, y + other.y)
    }
    operator fun minus(other: Point): Point {
        return Point(x - other.x, y - other.y)
    }
    operator fun times(other: Point): Point {
        return Point(x * other.x, y * other.y)
    }
    operator fun times(scalar: Int): Point {
        return Point(x * scalar, y * scalar)
    }
    operator fun times(scalar: Float): Point {
        return Point(x * scalar, y * scalar)
    }
    operator fun times(scalar: Double): Point {
        return Point(x * scalar.toFloat(), y * scalar.toFloat())
    }
    operator fun div(other: Point): Point {
        return Point(x / other.x, y / other.y)
    }
    operator fun div(divisor: Int): Point {
        return Point(x / divisor, y / divisor)
    }
    operator fun div(divisor: Float): Point {
        return Point(x / divisor, y / divisor)
    }
    operator fun div(divisor: Double): Point {
        return Point(x / divisor.toFloat(), y / divisor.toFloat())
    }

    fun clone(): Point{
        return Point(this.x, this.y)
    }
    // ----- get the point rotated around another pivot ----- //
    fun rotate(angle: Float, pivot: Point): Point {
        var p = clone()
        val s = sin(angle.toDouble())
        val c = cos(angle.toDouble())

        p -= pivot

        val x = p.x * c - p.y * s
        val y = p.x * s + p.y * c

        p.x = (x + pivot.x).toFloat()
        p.y = (y + pivot.y).toFloat()
        return p
    }
    // ----- get the dot product of the vector and another ----- //
    fun dot(other: Point): Float{
        return (x * other.x) + (y * other.y)
    }
    // ----- get the squared length of this vector ----- //
    fun length2(): Float{
        return dot(this)
    }
    // ----- get the length of this vector ----- //
    fun length(): Float{
        return sqrt(length2())
    }
    fun vector(other: Point): Vector{
        return Vector(other.x-x,other.y-y)
    }

}
