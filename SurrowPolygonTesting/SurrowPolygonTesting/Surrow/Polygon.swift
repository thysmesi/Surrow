import Foundation
import LibTessSwift

public class Polygon: CustomStringConvertible, Hashable, Codable {
    
    
    // MARK: - Independents
    var points: [Point] = [] {
        didSet {
            _vertices = nil
            _sides = nil
            _edges = nil
            _pne = nil
            _center = nil
            _bounding = nil
            _triangles = nil
            _orientation = nil
            _convex = nil
        }
    }
    
    
    // MARK: - Dependents
    /// A two way ordered linked list of vertices
    var vertices: [Vertex] {
        if _vertices == nil {
            _vertices = []
            for point in points {
                _vertices.append(Vertex(position: point))
            }
            for index in _vertices.indices {
                _vertices[index].last = _vertices[index == 0 ? _vertices.count - 1 : index - 1]
                _vertices[index].next = _vertices[index == _vertices.count - 1 ? 0 : index + 1]
            }
        }
        return _vertices
    }
    private var _vertices: [Vertex]! = nil
    
    /// A list of sides as segments
    var sides: [Segment] {
        if _sides == nil {
            _sides = []
            for index in points.indices {
                _sides.append(Segment(p1: points[index], p2: points[index == points.count - 1 ? 0 : index + 1]))
            }
        }
        return _sides
    }
    private var _sides: [Segment]! = nil
    
    /// A list of the sides as vectors
    var edges: [Vector] {
        if _edges == nil {
            _edges = []
            for index in points.indices {
                _edges.append(points[index].delta(to: points[index == points.count - 1 ? 0 : index + 1]))
            }
        }
        return _edges
    }
    private var _edges: [Vector]! = nil
    
    /// A list of normal perpendicular edges - Used as the test axises in SAT
    private var pne: [Vector] {
        if _pne == nil {
            _pne = edges.map { $0.perpendicular.normal }
        }
        return _pne
    }
    private var _pne: [Vector]! = nil
    
    /// The polygons center point
    var center: Point {
        if _center == nil {
            var sum = Point.origin
            for point in points {
                sum += point
            }
            _center = sum / Double(points.count)
        }
        return _center
    }
    private var _center: Point! = nil
    
    /// A bounding box
    var bounding: Box {
        if _bounding == nil {
            var min = points[0]
            var max = points[0]
            for point in points {
                min.x = Swift.min(min.x, point.x)
                max.x = Swift.max(max.x, point.x)
                min.y = Swift.min(min.y, point.y)
                max.y = Swift.max(max.y, point.y)
            }
            _center = (min + max) / 2
            _bounding = Box(position: _center, size: (max - min).size)
        }
        return _bounding
    }
    private var _bounding: Box! = nil
    
    /// A list of triangles that make up the polygon useful for for rendering
    var triangles: [Polygon] {
        if _triangles == nil {
            let polySize = 3

            let contour = points.map {
                CVector3(x: Float($0.x), y: Float($0.y), z: 0.0)
            }
    
            let tess = TessC()!
    
            tess.addContour(contour)
    
            try! tess.tessellate(windingRule: .evenOdd, elementType: .polygons, polySize: polySize)
    
            var result: [Point] = []
            var indices: [Int] = []
    
            for vertex in tess.vertices! {
                result.append(Point(Double(vertex.x), Double(vertex.y)))
            }
    
            for i in 0..<tess.elementCount
            {
                for j in 0..<polySize
                {
                    let index = tess.elements![i * polySize + j]
                    if (index == -1) {
                        continue
                    }
                    indices.append(index)
                }
            }
    
            _triangles  = []
            for indicesIndex in indices.indices {
                if indicesIndex % 3 == 0 {
                    _triangles.append(Polygon(points: [
                        result[indices[indicesIndex]],
                        result[indices[indicesIndex+1]],
                        result[indices[indicesIndex+2]],
                    ]))
                }
            }
        }
        return _triangles
    }
    private var _triangles: [Polygon]! = nil
    
    /// Tells whether the list of points is in a clockwise or counterclockwise orientation
    var orientation: Orientation {
        if _orientation == nil {
            var sum = 0.0
            for vertex in vertices {
                sum += (vertex.next.position.x - vertex.position.x)*(vertex.next.position.y + vertex.position.y)
            }
            if sum < 0 {
                _orientation = .clockwise
            } else {
                _orientation = .counterClockwise
            }
        }
        return _orientation
    }
    private var _orientation: Orientation! = nil
    
    /// returns whether the polygon is convex or not
    var convex: Bool {
        if _convex == nil {
            var convex = true
            let positive = vertices[0].cross > 0
            for index in 1..<vertices.count {
                if (vertices[index].cross > 0) != positive {
                    convex = false
                    break
                }
            }
            _convex = convex
        }
        return _convex
    }
    private var _convex: Bool! = nil
    
    /// returns whether the polygon is concave or not
    var concave: Bool {
        !convex
    }
    
    /// Returns whether this polygon is a triangle or not
    var triangle: Bool {
        points.count == 3
    }
    
    /// Returns whether this polygon is a rectangle or not
    var rectangle: Bool {
        points.count == 4
    }
    
    
    // MARK: - Initializers
    init(points: [Point]) {
        self.points = points
    }
    init(_ polygon: Polygon) {
        self.points = polygon.points
        _vertices = polygon._vertices
        _sides = polygon._sides
        _edges = polygon._edges
        _pne = polygon._pne
        _center = polygon._center
        _bounding = polygon._bounding
        _triangles = polygon._triangles
        _orientation = polygon._orientation
        _convex = polygon._convex
    }
    
    
    // MARK: - Testing
    // ----- Seperating Axis Theorem ----- //
    private func flatten(points: [Point], on axis: Vector) -> ClosedRange<Double> {
        var min = Double.greatestFiniteMagnitude
        var max = -Double.greatestFiniteMagnitude
        
        for point in points {
            let dot = point.dot(axis)
            min = Swift.min(min, dot)
            max = Swift.max(max, dot)
        }
        return min...max
    }
    private func isSeperating(axis: Vector, seperating points1: [Point], and points2: [Point]) -> Double? {
        let range1 = flatten(points: points1, on: axis)
        let range2 = flatten(points: points2, on: axis)
        
        if !range1.overlaps(range2) {
            return nil
        }
        
        let option1 = range1.upperBound - range2.lowerBound
        let option2 = range2.upperBound - range1.lowerBound
        return option1 < option2 ? option1 : -option2
    }
    private func testConvexConvex(_ first: Polygon, _ second: Polygon) -> Vector? {
        var smallest: Vector? = nil
        
        for axis in first.pne + second.pne {
            if let overlap = isSeperating(axis: axis, seperating: first.points, and: second.points) {
                let vector = (axis * overlap)
                if smallest == nil || smallest!.length > abs(overlap) {
                    smallest = vector
                }
            } else {
                return nil
            }
        }
        
        return smallest
    }
    
    // ----- Colliding ----- //
    public func collides(with other: Polygon) -> Vector? {
        if convex && other.convex {
            return testConvexConvex(self, other)
        }
        return nil
    }

    
    // MARK: - Adjustments
    public func rotated(degrees: Double) -> Polygon {
        Polygon(points: points.map { $0.rotated(around: center, degrees: degrees) } )
    }
    
    
    // MARK: - Statics
    class Vertex {
        
        
        // MARK: - Vertex.Independents
        let position: Point
        var next: Vertex! {
            didSet {
                _second = nil
                _cross = nil
            }
        }
        var last: Vertex! {
            didSet {
                _first = nil
                _cross = nil
            }
        }
        
        
        // MARK: - Vertex.Dependents
        /// Vector that goes from last position to current position
        var first: Vector {
            if _first == nil {
               _first = last.position.delta(to: position)
            }
            return _first
        }
        private var _first: Vector! = nil
        
        /// Vector that goes from current position to the next position
        var second: Vector {
            if _second == nil {
                _second = position.delta(to: next.position)
            }
            return _second
        }
        private var _second: Vector! = nil

        /// cross prodect of the first and second vectors
        var cross: Double {
            if _cross == nil {
                _cross = first.cross(second)
            }
            return _cross
        }
        private var _cross: Double! = nil

        
        // MARK: - Vertex.Initializers
        init(position: Point, next: Vertex? = nil, last: Vertex? = nil){
            self.position = position
            self.next = next
            self.last = last
        }
    }
    
    enum Orientation {
        case clockwise
        case counterClockwise
    }
    
    
    // MARK: - Conformance
    // ----- CustomStringConvertable ----- //
    lazy public var description: String = "Polygon(points: \(points.count))"
    
    // ----- Equatable ----- //
    let id = UUID()
    public static func == (lhs: Polygon, rhs: Polygon) -> Bool {
        lhs.id == rhs.id
    }
    
    // ----- Hashable ----- //
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // ----- Codable ----- //
    private enum CodingKeys: String, CodingKey {
        case points
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.points = try container.decode([Point].self, forKey: .points)
    }
    
    
    // MARK: - Operators
    public static func +(lhs: Polygon, rhs: Vector) -> Polygon {
        Polygon(points: lhs.points.map { $0 + rhs } )
    }
    public static func +=(lhs: inout Polygon, rhs: Vector) {
        lhs.points = lhs.points.map { $0 + rhs }
    }
    
    public static func -(lhs: Polygon, rhs: Vector) -> Polygon {
        Polygon(points: lhs.points.map { $0 - rhs } )
    }
    public static func -=(lhs: inout Polygon, rhs: Vector) {
        lhs.points = lhs.points.map { $0 - rhs }
    }
    
    public static func *(lhs: Polygon, rhs: Vector) -> Polygon {
        Polygon(points: lhs.points.map { $0 * rhs } )
    }
    public static func *=(lhs: inout Polygon, rhs: Vector) {
        lhs.points = lhs.points.map { $0 * rhs }
    }
    
    public static func /(lhs: Polygon, rhs: Vector) -> Polygon {
        Polygon(points: lhs.points.map { $0 / rhs } )
    }
    public static func /=(lhs: inout Polygon, rhs: Vector) {
        lhs.points = lhs.points.map { $0 / rhs }
    }
    
    public static func +(lhs: Polygon, rhs: Double) -> Polygon {
        Polygon(points: lhs.points.map { $0 + rhs } )
    }
    public static func +=(lhs: inout Polygon, rhs: Double) {
        lhs.points = lhs.points.map { $0 + rhs }
    }

    public static func -(lhs: Polygon, rhs: Double) -> Polygon {
        Polygon(points: lhs.points.map { $0 - rhs } )
    }
    public static func -=(lhs: inout Polygon, rhs: Double) {
        lhs.points = lhs.points.map { $0 - rhs }
    }

    public static func *(lhs: Polygon, rhs: Double) -> Polygon {
        Polygon(points: lhs.points.map { $0 * rhs } )
    }
    public static func *=(lhs: inout Polygon, rhs: Double) {
        lhs.points = lhs.points.map { $0 * rhs }
    }

    public static func /(lhs: Polygon, rhs: Double) -> Polygon {
        Polygon(points: lhs.points.map { $0 / rhs } )
    }
    public static func /=(lhs: inout Polygon, rhs: Double) {
        lhs.points = lhs.points.map { $0 / rhs }
    }
}
