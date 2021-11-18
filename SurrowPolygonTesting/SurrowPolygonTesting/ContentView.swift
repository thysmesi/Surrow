//
//  ContentView.swift
//  SurrowPolygonTesting
//
//  Created by Corbin Bigler on 11/17/21.
//

import SwiftUI

class ViewModel: ObservableObject {
    let points = [
        Point(87, 43),
        Point(218, 98),
        Point(195, 171),
        Point(224, 256),
        Point(181, 329),
        Point(84, 329),
        Point(147, 205),
        Point(104, 133),
        Point(24, 92)
    ].reversed().map {$0 * 1.5 + Vector(0, 300)}
    let polygon = Polygon(points: [
        Point(87, 43),
        Point(218, 98),
        Point(195, 171),
        Point(224, 256),
        Point(181, 329),
        Point(84, 329),
        Point(147, 205),
        Point(104, 133),
        Point(24, 92)
    ].reversed().map {$0 * 1.5 + Vector(0, 300)})
    
    var polygon2 = Polygon(points: [
        Point(0,0),
        Point(100,0),
        Point(100,100),
        Point(0,100)
    ])
    
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
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            Color.black
            PolygonShape(polygon: viewModel.polygon)
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
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
