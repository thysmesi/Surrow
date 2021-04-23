package sat

import kotlin.math.*

fun Float.formatDecimal(numberOfDecimals: Int = 2): String = "%.${numberOfDecimals}f".format(this)

data class Vector(var x: Float = 0F, var y: Float = 0F){
    // ----- copy the coordinates of another vector to this one ----- //
    fun copy(other: Vector): Vector{
        x = other.x
        y = other.y
        return this
    }

    // ----- create a new vector with the same coordinates ----- //
    fun clone(): Vector{
        return Vector(x, y)
    }

    // ----- change this vector to be perpendicular to what it was before ----- //
    fun perp(): Vector {
        val prevX = x
        x = y
        y = -prevX
        return this
    }

    // ----- rotate this vector (counter-clockwise) in radians ----- //
    fun rotate(angle: Float): Vector{
        val prevX = x
        val prevY = y
        x = round(prevX * cos(angle) - prevY * sin(angle))
        y = round(prevX * sin(angle) + prevY * cos(angle))
        return this
    }

    // ----- reverse this vector ----- //
    fun reverse(): Vector{
        x *= -1
        y *= -1
        return this
    }

    // ----- normalize this vector (have length of 1) ----- //
    fun normalize(): Vector{
        val d = this.len()
        if(d > 0) {
            x /= d
            y /= d
        }
        return this
    }

    // ----- add another vector to this ----- //
    fun add(other: Vector): Vector{
        x += other.x
        y += other.y
        return  this
    }

    // ----- subtract another vector from this ----- //
    fun sub(other: Vector): Vector{
        x -= other.x
        y -= other.y
        return  this
    }

    // ----- subtract another vector from this ----- //
    fun div(other: Vector): Vector{
        x /= other.x
        y /= other.y
        return  this
    }

    // ----- scale this based off another vector  ----- //
    fun scale(other: Vector): Vector {
        x *= other.x
        y *= other.x
        return this
    }

    // ----- scale this based off a number ----- //
    fun scale(scalar: Float): Vector{
        x *= scalar
        y *= scalar
        return this
    }

    // ----- project this vector on to another vector ----- //
    fun project(other: Vector): Vector{
        val amt = dot(other) / other.len2()
        x = amt * other.x
        y = amt * other.y
        return this
    }

    // ----- project this vector onto a unit vector ----- //
    fun projectN(other: Vector): Vector{
        val amt = this.dot(other)
        x = amt * other.x
        y = amt * other.y
        return  this
    }

    // ----- reflect this vector on a given axis ----- //
    fun reflect(axis: Vector): Vector{
        val prevX = x
        val prevY = y
        project(axis).scale(2F)
        x -= prevX
        y -= prevY
        return this
    }

    // ----- reflect this vector on a given unit vector axis ----- //
    fun reflectN(axis: Vector): Vector{
        val prevX = x
        val prevY = y
        projectN(axis).scale(2F)
        x -= prevX
        y -= prevY
        return this
    }

    // ----- get the dot product of the vector and another ----- //
    fun dot(other: Vector): Float{
        return (x * other.x) + (y * other.y)
    }

    // ----- get the squared length of this vector ----- //
    fun len2(): Float{
        return dot(this)
    }

    // ----- get the length of this vector ----- //
    fun len(): Float{
        return sqrt(len2())
    }

    // ----- get the distance between this vector (point) an another (point)----- //
    fun dist(other: Vector): Float{
        return sqrt((other.x - x).pow(2) + (other.y - y).pow(2))
    }
}