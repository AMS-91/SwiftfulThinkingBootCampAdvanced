//
//  CustomShapesBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 안민수 on 2022/04/25.
//

import SwiftUI


struct Triagle : Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        }
    }
    
}

struct Diamond : Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            let horizontalOffset: CGFloat = rect.width * 0.16
            
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX - horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX + horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}

struct Trapezoid : Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            let horizontalOffset: CGFloat = rect.width * 0.16

            path.move(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))

            
        }
    }
}

struct CustomShapesBootcamp: View {
    var body: some View {

        ZStack {
            
            Image("fire-and-water-g15c080b01_1920")
                .resizable()
                .scaledToFill()
//            Triagle()
//                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, dash: [10]))
//                .foregroundColor(.blue)
//                .fill(LinearGradient(gradient: Gradient(colors: [Color.red,Color.blue]), startPoint: .leading, endPoint: .trailing))
                .frame(width:300, height: 300)
                .clipShape(
                    Trapezoid()
//                        .rotation(Angle(degrees: 180))
                )
        }
        
    }
}

struct CustomShapesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CustomShapesBootcamp()
    }
}
