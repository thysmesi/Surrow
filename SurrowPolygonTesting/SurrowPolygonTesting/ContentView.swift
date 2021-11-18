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
    let points = [
        Point(87, 43),
        Point(195, 171),
        Point(181, 329),
        Point(84, 329),
        Point(24, 92)
    ].reversed().map {$0 * 1.5 + Vector(20, 200)}

    lazy var polygon = Polygon(points: points)
    
    var polygon2 = Polygon(points: [
        Point(0,0),
        Point(100,0),
        Point(100,100),
        Point(0,100)
    ].map {$0 + Vector(200, 250)})
    
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

//        let start = CFAbsoluteTimeGetCurrent()
//        for _ in 0..<100000 {
//            if let vector = polygon.collides(with: polygon2) {
//                polygon2 += vector
//            }
//        }
//        print(CFAbsoluteTimeGetCurrent() - start)

        RunLoop.main.add(Timer(timeInterval: 1/60, repeats: true, block: { [self] _ in
            polygon2 += Vector(0,3)

            if let vector = polygon.collides(with: polygon2) {
                polygon2 += vector
            }

            objectWillChange.send()
        }), forMode: .common)
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            Color.black
            PolygonPath(polygon: viewModel.polygon)
                .stroke(.white, lineWidth: 2)
            PolygonPath(polygon: viewModel.polygon2)
                .stroke(.white, lineWidth: 2)

            Path { path in
                for ear in viewModel.ears {
                    path.move(to: ear.vertices[0].position)
                    for vertex in ear.vertices {
                        path.addLine(to: vertex.next.position)
                    }
                }
            }
            .fill(.blue.opacity(0.25))
            Path { path in
                for ear in viewModel.ears {
                    path.move(to: ear.vertices[0].position)
                    for vertex in ear.vertices {
                        path.addLine(to: vertex.next.position)
                    }
                }
            }
            .stroke(.white)

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
