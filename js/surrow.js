class Point{
    constructor(x, y){
        this.x = x
        this.y = y
    }
    rotated(center, degrees) {
        let radians = (degrees * (Math.PI / 180))

        let x = this.x
        let y = this.y
        
        x -= center.x
        y -= center.y

        let tx = ((cos(radians) * x) + (sin(radians) * y) + center.x).toFloat()
        y = ((cos(radians) * y) - (sin(radians) * x) + center.y).toFloat()
        x = tx

        return new Point(x, y)
    }

}

class Line{
    constructor(p1, p2){
        this.p1 = p1
        this.p2 = p2
    }
    slope(){
        return (p2.y - p1.y) / (p2.x - p1.x)
    }
    midPoint(){
        return new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2)
    }
    y(x){
        let slope = slope()
        if(slope == 0) return p1.y
        return (slope * x) - (slope * p1.x) + p1.y
    }
    x(y){
        let slope = slope()
        if(slope == 0) return 0
        return (y / slope) - (p1.x / slope) + p1.y
    }
    test(line) {
        let slope = slope()
        let yIntercept = yIntercept()
        if (slope == line.slope()) {
            return null
        }
        let x = (line.yIntercept() - yIntercept) / (slope - line.slope())
        let y = slope * x + yIntercept
        return Point(x, y)
    }
}