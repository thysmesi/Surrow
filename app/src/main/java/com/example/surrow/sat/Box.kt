package com.example.gameengine.sat

import android.graphics.Rect
import sat.Vector

data class Box(val position: Vector = Vector(), val width: Float = 0F, val height: Float = 0F){

    val left: Float
        get(){
            return position.x
        }
    val right: Float
        get(){
            return position.x + width
        }
    val top: Float
        get(){
            return position.y
        }
    val bottom: Float
        get(){
            return position.y + height
        }
    val rect: Rect
        get(){
            return Rect(left.toInt(), top.toInt(), right.toInt(), bottom.toInt())
        }

    // ----- creates a Polygon based off Box ----- //
    fun toPolygon(): Polygon {
        return Polygon(
            Vector(position.x, position.y), mutableListOf(
            Vector(), Vector(width, 0F),
            Vector(width, height), Vector(0F, height)
        ))
    }
}