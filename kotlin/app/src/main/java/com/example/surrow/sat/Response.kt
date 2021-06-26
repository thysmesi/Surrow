package com.example.gameengine.sat

import sat.Vector

data class Response(
    var aInB: Boolean = true,
    var bInA: Boolean = true,
    var overlap: Float = Float.MAX_VALUE,
    var overlapN: Vector = Vector(),
    var overlapV: Vector = Vector()
    )