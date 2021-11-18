import Foundation

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
            _triangles = []
            
            var choping: [Polygon.Vertex] = []
            
            for vertex in vertices {
                choping.append(Polygon.Vertex(position: vertex.position))
            }
            for index in choping.indices {
                choping[index].last = choping[index == 0 ? choping.count - 1 : index - 1]
                choping[index].next = choping[index == choping.count - 1 ? 0 : index + 1]
            }
            
            var tick = 0
            func chop(index: Int) {
                tick += 1
                let vertex = choping[index]
                if  (orientation == .clockwise && vertex.cross > 0) ||
                    (orientation == .counterClockwise && vertex.cross < 0) {
                    if choping.count == 3 {
                        _triangles.append(Polygon(points: [choping[0].position,choping[1].position,choping[2].position]))
                    } else {
                        _triangles.append(Polygon(points: [vertex.last.position,vertex.position,vertex.next.position]))

                        vertex.last.next = vertex.next
                        vertex.next.last = vertex.last
                        choping.remove(at: index)
                        chop(index: index >= choping.count - 1 ? 0 : index + 1)
                    }
                } else {
                    if choping.count > 3 {
                        chop(index: index == choping.count - 1 ? 0 : index + 1)
                    }
                }
            }
            chop(index: 0)
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
    public static func -(lhs: Polygon, rhs: Vector) -> Polygon {
        Polygon(points: lhs.points.map { $0 - rhs } )
    }
    public static func *(lhs: Polygon, rhs: Vector) -> Polygon {
        Polygon(points: lhs.points.map { $0 * rhs } )
    }
    public static func /(lhs: Polygon, rhs: Vector) -> Polygon {
        Polygon(points: lhs.points.map { $0 / rhs } )
    }
    public static func +(lhs: Polygon, rhs: Double) -> Polygon {
        Polygon(points: lhs.points.map { $0 + rhs } )
    }
    public static func -(lhs: Polygon, rhs: Double) -> Polygon {
        Polygon(points: lhs.points.map { $0 - rhs } )
    }
    public static func *(lhs: Polygon, rhs: Double) -> Polygon {
        Polygon(points: lhs.points.map { $0 * rhs } )
    }
    public static func /(lhs: Polygon, rhs: Double) -> Polygon {
        Polygon(points: lhs.points.map { $0 / rhs } )
    }
}
