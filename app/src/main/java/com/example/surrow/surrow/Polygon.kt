package com.example.surrow.surrow

import kotlin.math.abs

class Polygon {
    var position: Point
    val originals: List<Point>
    val points: List<Point>
        get(){
            val calcPoints = mutableListOf<Point>()
            originals.forEach { original ->
                calcPoints.add(original.rotate(angle, centroid))
            }
            return calcPoints
        }
    val edges: List<Vector>
        get(){
            val calcEdges = mutableListOf<Vector>()
            points.forEachIndexed { index, _ ->
                val p1 = points[index]
                val p2 = if(index < points.size - 1) points[index+1] else points[0]
                calcEdges.add(p1.vector(p2))
            }
            return calcEdges
        }
    val normals: List<Point>
        get(){
            val calcNormals = mutableListOf<Point>()
            edges.forEach { edge ->
                calcNormals.add(edge.perp().normalize().toPoint())
            }
            return calcNormals
        }
    var angle: Float

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
            return Box(position + (Point(xMin, yMin)), xMax - xMin, yMax - yMin)
        }
    // ----- the center point of the Polygon ----- //
    val centroid: Point
        get(){
            var centerSum = Point(0f,0f)
            var weightSum = 0f
            originals.forEachIndexed { index, _ ->
                val p1 = originals[index]
                val p2 = if(index == originals.size - 1) originals[0] else originals[index+1]
                val weight = (p1 - p2).length() + (p1 - p2).length()
                centerSum += p1 * weight
                weightSum += weight
            }

            return centerSum / weightSum
        }
    // ----- the area of the Polygon ----- //
    val area: Float
        get(){
            var xSum = 0F
            var ySum = 0F
            originals.forEachIndexed { index, _ ->
                if (index < originals.size - 1) {
                    xSum += (originals[index].x * originals[index+1].y)
                    ySum += (originals[index].y * originals[index+1].x)
                }
            }
            return (xSum - ySum) / 2
        }

    fun test(other: Polygon): Vector{
        fun flattenPointsOn(points: List<Point>, normal: Point): MutableList<Float> {
            var min = Float.MAX_VALUE
            var max = -Float.MAX_VALUE
            points.forEach { point ->
                val dot = point.dot(normal)
                if(dot < min) min = dot
                if(dot > max) max = dot
            }

            return mutableListOf(min, max)
        }
        fun isSeparatingAxis(aPos: Point, bPos: Point, aPoints: List<Point>, bPoints: List<Point>, axis: Point): Vector? {
            val offsetV = aPos.vector(bPos)
            val projectedOffset = offsetV.dot(axis)

            val rangeA = flattenPointsOn(aPoints, axis)
            val rangeB = flattenPointsOn(bPoints, axis)

            rangeB[0] += projectedOffset
            rangeB[1] += projectedOffset

            if(rangeA[0] > rangeB[1] || rangeB[0] > rangeA[1]) {
                return null
            }

            var overlap = 0F
            if(rangeA[0] < rangeB[0]) {
                overlap = if (rangeA[1] < rangeB[1]) {
                    rangeA[1] - rangeB[0]
                } else {
                    val option1 = rangeA[1] - rangeB[0]
                    val option2 = rangeB[1] - rangeA[0]
                    if(option1 < option2) option1 else -option2
                }
            } else {
                overlap = if(rangeA[1] > rangeB[1]) {
                    rangeA[0] - rangeB[1]
                } else {
                    val option1 = rangeA[1] - rangeB[0]
                    val option2 = rangeB[1] - rangeA[0]
                    if(option1 < option2) option1 else -option2
                }
            }

            val p = axis * abs(overlap)
            return Vector(p.x, p.y)
        }

        var overlap = Vector(0f,0f)
        points.forEachIndexed { index, _ ->
            val result = isSeparatingAxis(position, other.position, points, other.points, normals[index])
            if(result == null){
                return Vector(0f, 0f)
            } else {
                if(result > overlap){
                    overlap = result
                }
            }

        }
        other.points.forEachIndexed { index, _ ->
            val result = isSeparatingAxis(position, other.position, points, other.points, other.normals[index])
            if(result == null){
                return Vector(0f, 0f)
            } else {
                if(result > overlap){
                    overlap = result
                }
            }
        }

        return overlap
    }

    // ----- construct the polygon off of position and points list ----- //
    constructor(position: Point, points: List<Point>, angle: Float = 0f){
        this.position = position
        this.originals = points
        this.angle = angle
    }

    // ----- construct the polygon off of a box ----- //
    constructor(box: Box, angle: Float = 0f){
        this.position = box.position
        this.originals = listOf(
            Point(0f, 0f), Point(box.width,0f),
            Point(box.width,  box.height), Point(0f, box.height)
        )
        this.angle = angle
    }
}