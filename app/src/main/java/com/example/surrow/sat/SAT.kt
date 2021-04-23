package sat

import com.example.gameengine.sat.Circle
import com.example.gameengine.sat.Polygon
import com.example.gameengine.sat.Response
import kotlin.math.abs
import kotlin.math.sqrt

class SAT(){
    // ----- test if point is in circle ----- //
    fun test(point: Vector, circle: Circle): Response?{
        val differenceV = point.clone().sub(circle.position)
        val radiusSq = circle.radius * circle.radius
        val distanceSq = differenceV.len2()

        if(distanceSq <= radiusSq){
            val overlap =  abs(sqrt(distanceSq) - sqrt(radiusSq))
            val overlapN = differenceV.clone().normalize().reverse()

            return Response(
                aInB = true,
                bInA = false,
                overlap = overlap,
                overlapN = overlapN,
                overlapV = overlapN.clone().scale(overlap)
            )
        }
        return null
    }

    // ----- return if point is in or out of polygon ----- //
    fun pointIn(point: Vector, polygon: Polygon): Boolean{
        var left = 0
        var right = 0

        polygon.calcPoints.forEachIndexed { index, _ ->
            if(point == polygon.calcPoints[index]) return true

            val p1 = polygon.calcPoints[index].clone().add(polygon.position)
            val p2 = (if(index < polygon.calcPoints.size - 1) polygon.calcPoints[index+1] else polygon.calcPoints[0]).clone().add(polygon.position)

            val d = (point.x - p1.x) * (p2.y - p1.y) - (point.y - p1.y) * (p2.x - p1.x)

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

    // ----- test polygon | polygon ----- //
    fun test(a: Polygon, b: Polygon): Response?{
        val aPoints = a.calcPoints
        val bPoints = b.calcPoints

        val response = Response()

        aPoints.forEachIndexed { index, _ ->
            if(isSeparatingAxis(a.position, b.position, aPoints, bPoints, a.normals[index], response)){
                return null
            }
        }
        bPoints.forEachIndexed { index, _ ->
            if(isSeparatingAxis(a.position, b.position, aPoints, bPoints, b.normals[index], response)){
                return null
            }
        }

        response.overlapV.copy(response.overlapN).scale(response.overlap)
        return response
    }

    // ----- test polygon | circle ----- //
    fun test(polygon: Polygon, circle: Circle): Response? {
        val response = Response()
        val circlePos = Vector().copy(circle.position).sub(polygon.position)
        val radius = circle.radius
        val radius2 = radius * radius
        val points = polygon.calcPoints
        val len = points.size
        val edge = Vector()
        val point = Vector()

        polygon.calcPoints.forEachIndexed { index, _ ->
            val next = if(index == len - 1) 0 else index + 1
            val prev = if(index == 0) len - 1 else index - 1
            var overlap = 0F
            var overlapN: Vector? = null

            edge.copy(polygon.edges[index])
            point.copy(circlePos).sub(points[index])

            if(point.len2() > radius2){
                response.aInB = false
            }

            var region = voronoiRegion(edge, point)

            if(region == VORONOI_REGION.LEFT) {
                edge.copy(polygon.edges[prev])

                val point2 = Vector().copy(circlePos).sub(points[prev])
                region = voronoiRegion(edge, point2)
                if (region == VORONOI_REGION.RIGHT) {
                    val dist = point.len()
                    if(dist > radius) {
                        return null
                    } else {
                        response.bInA = false
                        overlapN = point.normalize()
                        overlap = radius - dist
                    }
                }
            } else if(region == VORONOI_REGION.RIGHT) {
                edge.copy(polygon.edges[next])

                point.copy(circlePos).sub(points[next])
                region = voronoiRegion(edge, point)
                if(region == VORONOI_REGION.LEFT){
                    var dist = point.len()
                    if(dist > radius) {
                        return null
                    } else {
                        response.bInA = false
                        overlapN = point.normalize()
                        overlap = radius - dist
                    }
                }
            } else {
                val normal = edge.perp().normalize()

                val dist = point.dot(normal)
                val distAbs = abs(dist)

                if(dist > 0 && distAbs > radius){
                    return null
                } else {
                    overlapN = normal
                    overlap = radius - dist

                    if(dist >= 0 || overlap < 2 * radius) {
                        response.bInA = false
                    }
                }
            }

            if(overlapN != null && abs(overlap) < abs(response.overlap)) {
                response.overlap = overlap
                response.overlapN.copy(overlapN)
            }
        }

        response.overlapV.copy(response.overlapN).scale(response.overlap)
        return response
    }

    // ----- test circle | circle ----- //
//    fun test(circle: Circle, polygon: Polygon): Response? {
//        val result = test(polygon, circle)
//        if(result != null){
//            val aInB = result.aInB
//            result.overlapN.reverse()
//            result.overlapV.reverse()
//            result.aInB = result.bInA
//            result.bInA = aInB
//        }
//        return result
//    }

    // ----- test circle | polygon ----- //
    fun test(a: Circle, b: Circle): Response? {
        val response = Response()
        val differenceV = Vector().copy(b.position).sub(a.position)
        val totalRadius = a.radius + b.radius
        val totalRadiusSq = totalRadius * totalRadius
        val distanceSq = differenceV.len2()

        if(distanceSq > totalRadiusSq) {
            return null
        }

        if(response != null) {
            val dist = sqrt(distanceSq)
            response.overlap = totalRadius - dist
            response.overlapN.copy(differenceV.normalize())
            response.overlapV.copy(differenceV).scale(response.overlap)
            response.aInB = a.radius <= b.radius && dist <= b.radius - a .radius
            response.bInA =  b.radius <= a.radius && dist <= a.radius - b.radius
        }
        return response
    }

    private fun flattenPointsOn(points: List<Vector>, normal: Vector): MutableList<Float> {
        var min = Float.MAX_VALUE
        var max = -Float.MAX_VALUE
        points.forEach { point ->
            val dot = point.dot(normal)
            if(dot < min) min = dot
            if(dot > max) max = dot
        }

        return mutableListOf(min, max)
    }

    private fun isSeparatingAxis(aPos: Vector, bPos: Vector, aPoints: MutableList<Vector>, bPoints: MutableList<Vector>, axis: Vector, response: Response): Boolean {
        val offsetV = Vector().copy(bPos).sub(aPos)
        val projectedOffset = offsetV.dot(axis)

        val rangeA = flattenPointsOn(aPoints, axis)
        val rangeB = flattenPointsOn(bPoints, axis)

        rangeB[0] += projectedOffset
        rangeB[1] += projectedOffset

        if(rangeA[0] > rangeB[1] || rangeB[0] > rangeA[1]) {
            return true
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

        val absOverlap = abs(overlap)
        if(absOverlap < response.overlap) {
            response.overlap = absOverlap
            response.overlapN.copy(axis)
            if(overlap < 0) {
                response.overlapN.reverse()
            }
        }

        return false
    }

    private enum class VORONOI_REGION {
        LEFT,
        MIDDLE,
        RIGHT
    }

    private fun voronoiRegion(line: Vector, point: Vector): VORONOI_REGION {
        val len2 = line.len2()
        val dp = point.dot(line)

        return when {
            dp < 0 -> VORONOI_REGION.LEFT
            dp > len2 -> VORONOI_REGION.RIGHT
            else -> VORONOI_REGION.MIDDLE
        }
    }
}