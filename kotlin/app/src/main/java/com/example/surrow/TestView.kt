package com.example.surrow

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.view.View
import com.example.surrow.surrow.Box
import com.example.surrow.surrow.Circle
import com.example.surrow.surrow.Point
import com.example.surrow.surrow.Polygon

class TestView( context: Context) : View(context) {
    private val paint = Paint().apply { isAntiAlias = true }

    var a = Polygon(Point(50f,1000f), listOf(Point(0f,0f), Point(200f,0f), Point(300f, 100f), Point(200f, 200f), Point(0f, 200f)), 1.5708f)
    var b = Polygon(Point(305f,100f), listOf(Point(0f,0f), Point(200f,0f), Point(300f, 100f), Point(200f, 200f), Point(0f, 200f)), 1.5708f)
    var p = Point(100f,100f)
    var c = Circle(Point(150f, 1000f), 200f)
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
//        a.angle += 20f * (Math.PI / 180f).toFloat()
        p.y += 40
//        b.position.y += 15

        val res = p.test(a)

//        b.position -= res.toPoint()
        canvas.drawRect(p.x-5,p.y-5,p.x+5,p.y+5, paint)
//        canvas.drawCircle(c.position.x,c.position.y,c.radius,paint)
        drawPoly(a, canvas, paint)
//        drawPoly(b, canvas, paint)

        var c = a.points
        var d = a.edges
        invalidate()
    }
}