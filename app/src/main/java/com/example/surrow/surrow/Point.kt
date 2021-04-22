package com.example.surrow.surrow

import kotlin.math.cos
import kotlin.math.sin


data class Point(var x: Float, var y: Float){
    fun add(other: Point): Point{
        return Point(this.x + other.x, this.y + other.y)
    }
    fun clone(): Point{
        return Point(this.x, this.y)
    }
    fun rotate(angle: Float, pivot: Point): Point {
        var p = clone()
        val s = sin(angle.toDouble())
        val c = cos(angle.toDouble())

        p.x -= pivot.x
        p.y -= pivot.y

        val xnew = p.x * c - p.y * s
        val ynew = p.x * s + p.y * c

        p.x = (xnew + pivot.x).toFloat()
        p.y = (ynew + pivot.y).toFloat()
        return p
    }
}
