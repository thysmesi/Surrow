package com.example.gameengine.sat

import sat.Vector

class Polygon(var position: Vector, points: MutableList<Vector> = mutableListOf()){
    // ----- angle in degrees recalc() points when changed ----- //
    var angle = 0F
        set(value){
            field = value
            recalc()
        }

    // ----- list of Vector() reset calcPoint, edges, and normals when length is changed ----- //
    var points = mutableListOf<Vector>()
        set(value){
            val lengthChanged = points.isEmpty() || points.size != value.size
            if(lengthChanged){
                calcPoints = mutableListOf()
                edges = mutableListOf()
                normals = mutableListOf()

                value.forEach{
                    calcPoints.add(Vector())
                    edges.add(Vector())
                    normals.add(Vector())
                }
            }
            field = value
            recalc()
        }

    // ----- points with calculated angles ----- //
    var calcPoints = mutableListOf<Vector>()

    // ----- Vector with slope of edge(x: run, y: rise) ----- //
    var edges = mutableListOf<Vector>()

    // ----- points normalized given a percent between -100% and 100% ----- //
    var normals = mutableListOf<Vector>()

    // ----- the axis aligned bounding box surrounding the polygon ----- //
    val AABB: Box
        get(){
            var xMin = points[0].x
            var yMin = points[0].y
            var xMax = points[0].x
            var yMax = points[0].y
            points.forEach { point ->
                if(point.x < xMin) xMin = point.x
                else if(point.x > xMax) xMax = point.x
                if(point.y < yMin) yMin = point.y
                else if(point.y > yMax) yMax = point.y
            }
            return Box(position.clone().add(Vector(xMin, yMin)), xMax - xMin, yMax - yMin)
        }

    // ----- the center point of the Polygon ----- //
    val centroid: Vector
        get(){
            var cx = 0F
            var cy = 0F
            var ar = 0F
            points.forEachIndexed { index, point ->
                val p1 = point
                val p2 = if(index == points.size - 1) points[0] else points[index+1]
                val a = p1.x * p2.y - p2.x * p1.y
                cx += (p1.x + p2.x) * a
                cy += (p1.y + p2.y) * a
                ar += a
            }
            ar += ar * 3
            cx /= ar
            cy /= ar
            return Vector(cx, cy)
        }

    // ----- the area of the Polygon ----- //
    val area: Float
        get(){
            var xSum = 0F
            var ySum = 0F
            points.forEachIndexed { index, _ ->
                if (index < points.size - 1) {
                    xSum += (points[index].x * points[index+1].y)
                    ySum += (points[index].y * points[index+1].x)
                }
            }
            return (xSum - ySum) / 2
        }

    // ----- calculate edges, normals, and calcPoints ----- //
    private fun recalc(): Polygon {
        points.forEachIndexed { index, _ ->
            val calcPoint = calcPoints[index].copy(points[index])
            if(angle != 0F){
                calcPoint.rotate(angle)
            }

            calcPoints[index] = calcPoint
        }
        points.forEachIndexed { index, _ ->
            val p1 = calcPoints[index]
            val p2 = if(index < points.size - 1) calcPoints[index+1] else calcPoints[0]
            val e = edges[index].copy(p2).sub(p1)
            normals[index].copy(e).perp().normalize()
        }
        return this
    }

    // ----- points initialized here so setter runs ----- //
    init {
        this.points = points
    }
}