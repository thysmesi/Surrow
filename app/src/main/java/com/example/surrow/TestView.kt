package com.example.surrow

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.view.View
import com.example.surrow.surrow.Box
import com.example.surrow.surrow.Point
import com.example.surrow.surrow.Polygon

class TestView( context: Context) : View(context) {
    private val paint = Paint().apply { isAntiAlias = true }

    var a = Polygon(Point(100f,100f), listOf(Point(0f,0f), Point(100f,0f), Point(150f, 50f), Point(100f, 100f), Point(0f, 100f)), 0f)
    var b = Polygon(Point(500f,100f), listOf(Point(0f,0f), Point(100f,0f), Point(150f, 50f), Point(100f, 100f), Point(0f, 100f)), 0f)

    fun drawPoly(polygon: Polygon, canvas: Canvas, paint: Paint){
        canvas.save()
        canvas.translate(polygon.position.x,polygon.position.y)
        var path = Path()
        path.moveTo(polygon.points[0].x,polygon.points[0].y)
        polygon.points.forEach {
            path.lineTo(it.x,it.y)
        }
        path.close()
        paint.color = Color.BLACK
        canvas.drawPath(path,paint)
        canvas.restore()
    }
    override fun onDraw(canvas: Canvas) {
        canvas.drawColor(Color.LTGRAY)
        super.onDraw(canvas)
        //a.angle += 20f * (Math.PI / 180f).toFloat()
        b.position.x -= 15
        drawPoly(a, canvas, paint)
        drawPoly(b, canvas, paint)

        var res = a.test(b)
        //a.position -= res.toPoint()
        res
        invalidate()
    }
}