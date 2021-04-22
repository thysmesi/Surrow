package com.example.surrow

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Path
import android.view.View
import com.example.surrow.surrow.Box
import com.example.surrow.surrow.Point
import com.example.surrow.surrow.Polygon

class TestView( context: Context) : View(context) {
    private val paint = Paint().apply { isAntiAlias = true }

    var a = Polygon(Box(Point(100f,100f), 100f,100f), 20f)
    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        a.angle += 10f * (Math.PI / 180f).toFloat()
        canvas.save()
        canvas.translate(a.position.x,a.position.y)
        var path = Path()
        path.moveTo(a.points[0].x,a.points[0].y)
        a.points.forEach {
            path.lineTo(it.x,it.y)
        }
        path.close()
        canvas.drawPath(path,paint)
        canvas.restore()

        invalidate()
    }
}