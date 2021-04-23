package com.example.surrow.surrow

import kotlin.math.sqrt

class Vector(var x: Float, var y: Float) {
    operator fun plus(other: Vector): Vector {
        return Vector(x + other.x, y + other.y)
    }
    operator fun minus(other: Vector): Vector {
        return Vector(x - other.x, y - other.y)
    }
    operator fun times(other: Vector): Vector {
        return Vector(x * other.x, y * other.y)
    }
    operator fun times(other: Point): Vector {
        return Vector(x * other.x, y * other.y)
    }
    operator fun times(scalar: Int): Vector {
        return Vector(x * scalar, y * scalar)
    }
    operator fun times(scalar: Float): Vector {
        return Vector(x * scalar, y * scalar)
    }
    operator fun times(scalar: Double): Vector {
        return Vector(x * scalar.toFloat(), y * scalar.toFloat())
    }
    operator fun div(other: Vector): Vector {
        return Vector(x / other.x, y / other.y)
    }
    operator fun div(divisor: Int): Vector {
        return Vector(x / divisor, y / divisor)
    }
    operator fun div(divisor: Float): Vector {
        return Vector(x / divisor, y / divisor)
    }
    operator fun div(divisor: Double): Vector {
        return Vector(x / divisor.toFloat(), y / divisor.toFloat())
    }
    operator fun compareTo(other: Vector): Int {
        return if(length() < other.length()) -1 else if(length() == other.length()) 0 else 1
    }

    fun clone(): Vector {
        return Vector(x, y)
    }
    fun perp(): Vector {
        return Vector(y, -x)
    }
    fun normalize(): Vector{
        val d = this.length()
        val v = clone()
        if(d > 0) {
            v.x /= d
            v.y /= d
        }
        return v
    }
    // ----- get the dot product of the vector and another ----- //
    fun dot(other: Vector): Float{
        return (x * other.x) + (y * other.y)
    }
    fun dot(other: Point): Float{
        return dot(Vector(other.x,other.y))
    }
    // ----- get the squared length of this vector ----- //
    fun length2(): Float{
        return dot(this)
    }
    // ----- get the length of this vector ----- //
    fun length(): Float{
        return sqrt(length2())
    }
    fun toPoint(): Point{
        return Point(x,y)
    }
}