package com.example.gameengine.sat

import sat.Vector
import kotlin.math.PI
import kotlin.math.pow

data class Circle(val position: Vector, val radius: Float){
    // ----- the axis aligned bounding box surrounding the Circle ----- //
    val AABB: Box
        get(){
            val corner = position.clone().sub(Vector(radius, radius))
            return Box(corner, radius*2, radius*2)

        }

    // ----- the area of the Circle ----- //
    val area : Float
        get(){
            return PI.toFloat() * radius.pow(2)
        }
}