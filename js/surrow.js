class Vector{
    constructor(x, y){
        if(y == undefined){
            this.x = Math.cos(x)
            this.y = Math.sin(x)
        } else {
            this.x = x
            this.y = y    
        }
    }
    get length(){return Math.abs(Math.sqrt(Math.pow(this.x,2) + Math.pow(this.y,2)))}
    get normal(){
        let length = this.length
        let v = new Vector(x, y)
        if(length > 0) {
            v /= length
        }
        return v
    }
}

class Point{
    constructor(x, y){
        this.x = x
        this.y = y
    }
    to(other){return new Vector(other.x - this.x, other.y - this.y)}
    rotated(center, degrees) {
        let radians = ((360 - degrees) * (Math.PI / 180))

        let x = this.x
        let y = this.y
        
        x -= center.x
        y -= center.y

        let tx = ((Math.cos(radians) * x) + (Math.sin(radians) * y) + center.x)
        y = ((Math.cos(radians) * y) - (Math.sin(radians) * x) + center.y)
        x = tx

        return new Point(x, y)
    }
}

class Line{
    constructor(p1, p2){
        this.p1 = p1
        this.p2 = p2
    }
    yIntercept(){return this.y(0)}
    xIntercept(){return this.x(0)}
    slope(){
        return (this.p2.y - this.p1.y) / (this.p2.x - this.p1.x)
    }
    midPoint(){
        return new Point((this.p1.x + this.p2.x) / 2, (this.p1.y + this.p2.y) / 2)
    }
    y(x){
        let slope = this.slope()
        if(slope == 0) return this.p1.y
        return (slope * x) - (slope * this.p1.x) + this.p1.y
    }
    x(y){
        let slope = this.slope()
        if(slope == 0) return 0
        return (y / slope) - (this.p1.x / slope) + this.p1.y
    }
    test(line) {
        let slope = this.slope()
        let yIntercept = this.yIntercept()
        if(Math.abs(slope) == Infinity){
            return new Point(this.p1.x, line.y(this.p1.x))
        }
        if(Math.abs(line.slope) == Infinity){
            return new Point(line.p1.x, y(line.p1.x))
        }
        if (slope == line.slope()) {
            return null
        }
        let x = (line.yIntercept() - yIntercept) / (slope - line.slope())
        let y = slope * x + yIntercept
        return new Point(x, y)
    }
}

class Segment extends  Line{
    constructor(p1, p2){
        super(p1, p2)
    }
    max(){return new Point(Math.max(this.p1.x,this.p2.x), Math.max(this.p1.y,this.p2.y))}
    min(){return new Point(Math.min(this.p1.x,this.p2.x), Math.min(this.p1.y,this.p2.y))}
    test(segment) {
        let min = this.min()
        let max = this.max()
        let omin = segment.min()
        let omax = segment.max()
        let result = super.test(segment)
        if(result){
            if(result.x >= min.x && result.x <= max.x){
                if(result.y >= min.y && result.y <= max.y){
                    if(result.x >= omin.x && result.x <= omax.x){
                        if(result.y >= omin.y && result.y <= omax.y){
                            return result
                        }
                    }
                }
            }
        }
        return null
    }
}