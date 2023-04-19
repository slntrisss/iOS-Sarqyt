//
//  SchemeMapView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.04.2023.
//

import SwiftUI

struct SchemeMapView: View {
    let mapItem: MapItem
    @Binding var isSelected: Bool
    let disabled: Bool
    var body: some View {
        ZStack{
            Path { path in
                
                var points: [Point] = []
                
                path.move(to: CGPoint(x: startPosition.x, y: startPosition.y))
                
                
                for point in mapItem.items {
                    let joinPoints = hasNeighborNeedToBeJoined(points: points, point: point)
                    
                    path.addLine(to: CGPoint(x: CGFloat(point.x) * sizePerCell,
                                             y: CGFloat(point.y) * sizePerCell))
                    
                    
                    for joinPoint in joinPoints {
                        path.addLine(to: CGPoint(x: CGFloat(joinPoint.point.x) * sizePerCell,
                                                 y: CGFloat(joinPoint.point.y) * sizePerCell))
                        
                        path.addLine(to: CGPoint(x: CGFloat(point.x) * sizePerCell,
                                                 y: CGFloat(point.y) * sizePerCell))
                        
                    }
                    
                    points.append(point)
                }
                
            }
            .stroke(colorForItem,
                    style: StrokeStyle(lineWidth: sizePerItem, lineCap: .round, lineJoin: .round))
        }
    }
    
    private var sizePerCell: CGFloat{
        return 30
    }
    
    private var colorForItem: Color{
        if disabled{
            return .red.opacity(0.8)
        }
        else if isSelected{
            return Color.theme.blueColor
        }
        return Color.theme.secondaryText.opacity(0.3)
    }
    
    private var sizePerItem: CGFloat{
        switch mapItem.type{
        case .TABLE: return 30
        case .CHAIR: return 18
        case .SOFA: return 15
        default: return 10
        }
    }
    
    private var startPosition: (x: CGFloat, y: CGFloat){
        return (CGFloat(mapItem.items[0].x) * sizePerCell, CGFloat(mapItem.items[0].y) * sizePerCell)
    }
    
    private func hasNeighborNeedToBeJoined(points: [Point], point: Point) -> [JoinPoints]{
        var joinPoints: [JoinPoints] = []
        for visitedPoint in points{
            if visitedPoint.x == point.x - 1 && visitedPoint.y == point.y{
                joinPoints.append(JoinPoints(point: Point(x: point.x - 1, y: point.y)))
            }
            if visitedPoint.x == point.x && visitedPoint.y == point.y - 1{
                joinPoints.append(JoinPoints(point: Point(x: point.x, y: point.y - 1)))
            }
            if visitedPoint.x == point.x + 1 && visitedPoint.y == point.y{
                joinPoints.append(JoinPoints(point: Point(x: point.x + 1, y: point.y)))
            }
            if visitedPoint.x == point.x && visitedPoint.y == point.y + 1{
                joinPoints.append(JoinPoints(point: Point(x: point.x, y: point.y + 1)))
            }
        }
        return joinPoints
    }
    
    private struct JoinPoints{
        var point: Point
    }
}

struct SchemeMapView_Previews: PreviewProvider {
    static var previews: some View {
        SchemeMapView(mapItem: dev.scheme.floors.first!.groups[2].tableItem.first!,
                      isSelected: .constant(false), disabled: false)
    }
}
