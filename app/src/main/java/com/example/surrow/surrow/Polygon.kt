package com.example.surrow.surrow

class Polygon {
    var position: Point
    private val originals: List<Point>
    val points: List<Point>
        get(){
            val calcPoints = mutableListOf<Point>()
            originals.forEach { original ->
                calcPoints.add(original.rotate(angle, centroid))
            }
            return calcPoints
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
            return Box(position.add(Point(xMin, yMin)), xMax - xMin, yMax - yMin)
        }

    // ----- the center point of the Polygon ----- //
    val centroid: Point
        get(){
            var cx = 0F
            var cy = 0F
            var ar = 0F
            originals.forEachIndexed { index, point ->
                val p1 = point
                val p2 = if(index == originals.size - 1) originals[0] else originals[index+1]
                val a = p1.x * p2.y - p2.x * p1.y
                cx += (p1.x + p2.x) * a
                cy += (p1.y + p2.y) * a
                ar += a
            }
            ar += ar * 3
            cx /= ar
            cy /= ar
            return Point(cx, cy)
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