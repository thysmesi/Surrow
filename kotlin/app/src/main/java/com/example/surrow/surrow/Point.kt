package com.example.surrow.surrow

import kotlin.math.cos
import kotlin.math.pow
import kotlin.math.sin
import kotlin.math.sqrt


data class Point(var x: Float, var y: Float) {
    fun clone(): Point {
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

        p.x = (x + pivot.x).toInt().toFloat()
        p.y = (y + pivot.y).toInt().toFloat()
        return p
    }

    // ----- get the dot product of the point and another ----- //
    fun dot(other: Point): Float {
        return (x * other.x) + (y * other.y)
    }

    // ----- get the vector between two points----- //
    fun vector(other: Point): Vector {
        return Vector(other.x - x, other.y - y)
    }

    // ----- convert the point into a vector ----- //
    fun toVector(): Vector {
        return Vector(x, y)
    }

    fun test(circle: Circle): Boolean {
        val differenceV = (this - circle.position).toVector()
        val radiusSq = circle.radius.pow(2)
        val distanceSq = differenceV.length2();

        return distanceSq <= radiusSq
    }

    fun test(polygon: Polygon): Boolean {
        var left = 0
        var right = 0

        polygon.points.forEachIndexed { index, _ ->
            if (this == polygon.points[index]) return true

            val p1 = polygon.points[index] + polygon.position
            val p2 = (if (index < polygon.points.size - 1) polygon.points[index + 1] else polygon.points[0]) + polygon.position

            val d = (x - p1.x) * (p2.y - p1.y) - (y - p1.y) * (p2.x - p1.x)

            when {
                d > 0 -> left++
                d < 0 -> right++
            }

            if (left > 0 && right > 0) {
                return false
            }
        }
        return true
    }

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
}
