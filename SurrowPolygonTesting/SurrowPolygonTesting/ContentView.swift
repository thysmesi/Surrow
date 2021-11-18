//
//  ContentView.swift
//  SurrowPolygonTesting
//
//  Created by Corbin Bigler on 11/17/21.
//

import SwiftUI

class ViewModel: ObservableObject {
//    let points = [
//        Point(87, 43),
//        Point(218, 98),
//        Point(195, 171),
//        Point(224, 256),
//        Point(181, 329),
//        Point(84, 329),
//        Point(147, 205),
//        Point(104, 133),
//        Point(24, 92)
//    ].reversed().map {$0 * 1.5 + Vector(0, 300)}
//    let points = [
//        Point(87, 43),
//        Point(195, 171),
//        Point(181, 329),
//        Point(84, 329),
//        Point(24, 92)
//    ].reversed().map {$0 * 1.5 + Vector(20, 200)}
    let points = [Point(3368.48, 4035.64),
                  Point(3358.74, 4082.3),
                  Point(3309.52, 4268.72),
                   Point(3229.22, 4458.88),
                  Point(3151.52, 4599.0), Point(2983.14, 4594.0), Point(2882.12, 4443.86), Point(2788.86, 4443.86), Point(2685.26, 4508.92), Point(2568.7, 4646.54), Point(2462.48, 4844.18), Point(2449.54, 4921.76), Point(2581.66, 5054.38), Point(2705.98, 5099.4), Point(2759.94, 5117.86), Point(2721.24, 5169.38), Point(2509.54, 5413.82), Point(2543.48, 5580.4), Point(2455.84, 5722.38), Point(2297.5, 5839.84), Point(2062.86, 5946.32), Point(1921.48, 5897.18), Point(1743.38, 5979.1), Point(1608.72, 5940.66), Point(1612.86, 5798.52), Point(1636.18, 5648.38), Point(1628.4, 5498.26), Point(1716.48, 5353.14), Point(1737.2, 5223.04), Point(1848.58, 5072.92), Point(1983.28, 5067.9), Point(2208.64, 5067.9), Point(2320.02, 5000.34), Point(2400.32, 4812.68), Point(2470.26, 4710.1), Point(2509.12, 4577.5), Point(2452.12, 4509.96), Point(2312.24, 4522.78), Point(2180.14, 4539.98), Point(2050.64, 4522.78), Point(2020.72, 4516.86), Point(2066.6, 4426.56), Point(2096.88, 4342.96), Point(2240.88, 4288.96), Point(2344.88, 4196.96), Point(2404.88, 4030.96), Point(2572.88, 3902.96), Point(2713.58, 3892.74), Point(2785.58, 3824.32), Point(2924.88, 3802.96), Point(3046.88, 3914.96), Point(3162.88, 3926.96), Point(3264.92, 3878.2), Point(3335.46, 3905.54)].map {$0 * 0.2 - Vector(0, 750)}

    lazy var polygon = Polygon(points: points).rotated(degrees: 45)
    
    var polygon2 = Polygon(points: [
        Point(0,0),
        Point(100,0),
        Point(100,100),
        Point(0,100)
    ].map {$0 + Vector(200, 250)})
    
    let circle = Circle(position: Point(UIScreen.main.bounds.width/2, 10), radius: 50)
    let box = Box(position: Size(UIScreen.main.bounds.size).point / 2, size: Size(175, 80))
    var rotation = 0.0
    
    var ears: [Polygon] = []
    
    init() {
        print("--- Orientation ---")
        print(polygon.orientation)
        print(polygon2.orientation)
        print("\n")
        print("--- Convex ---")
        print(polygon.convex)
        print(polygon2.convex)
        print("\n")

        print(polygon.points[0])
        
        ears = polygon.triangles
//        let start = CFAbsoluteTimeGetCurrent()
//        for _ in 0..<100000 {
//            if let vector = polygon.collides(with: polygon2) {
//                polygon2 += vector
//            }
//        }
//        print(CFAbsoluteTimeGetCurrent() - start)

//        RunLoop.main.add(Timer(timeInterval: 1/60, repeats: true, block: { [self] _ in
//            circle.position += Vector(0,3)
//            rotation += 0.75
//
//            if let vector = circle.collides(with: box, degrees: rotation) {
//                circle.position += vector
//            }
            
//            objectWillChange.send()
//        }), forMode: .common)
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            Color.black
//            SwiftUI.Circle()
//                .stroke(.white, lineWidth: 2)
//                .frame(size: viewModel.circle.size)
//                .position(point: viewModel.circle.position)
//
//            PolygonPath(polygon: viewModel.box.polygon.rotated(degrees: viewModel.rotation))
//                .stroke(.white, lineWidth: 2)
            
            PolygonPath(polygon: viewModel.polygon)
                .stroke(.white, lineWidth: 2)
//            PolygonPath(polygon: viewModel.polygon2)
//                .stroke(.white, lineWidth: 2)
//
            Path { path in
                for ear in viewModel.ears {
                    path.move(to: ear.vertices[0].position)
                    for vertex in ear.vertices {
                        path.addLine(to: vertex.next.position)
                    }
                }
            }
            .fill(.blue.opacity(0.25))
//            Path { path in
//                for ear in viewModel.ears {
//                    path.move(to: ear.vertices[0].position)
//                    for vertex in ear.vertices {
//                        path.addLine(to: vertex.next.position)
//                    }
//                }
//            }
//            .stroke(.white)

        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global).onEnded { value in
            viewModel.polygon2.points = [
                Point(-50,-50),
                Point(50,-50),
                Point(50,50),
                Point(-50,50)
            ].map { $0 + Point(value.location) }
        })
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
