//
//  AnimatableDataBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 안민수 on 2022/05/01.
//

import SwiftUI

struct AnimatableDataBootcamp: View {
    
    @State private var animate: Bool = false
    
    var body: some View {
        ZStack {
            Pacman(cornerRadius: animate ? 25 : 0)
                .frame(width: 250, height: 250)
        }
        .onAppear {
            withAnimation(Animation.easeInOut.repeatForever()) {
                animate.toggle()
            }
        }
    }
}

struct AnimatableDataBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AnimatableDataBootcamp()
    }
}



struct RectangleWithdSingleCornerAnimation: Shape {
    
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat {
        
        // get = return value when I call
        get { cornerRadius }
        // set = what this animatable data should be, we can customize it to do togther things
        set { cornerRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 90),
                        clockwise: false)
            
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY ))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        }
    }
    
}



struct Pacman: Shape {
    
    var cornerRadius: Double
    
    var animatableData: Double {
        
        // get = return value when I call
        get { cornerRadius }
        // set = what this animatable data should be, we can customize it to do togther things
        set { cornerRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: rect.width / 2,
                        startAngle: Angle(degrees: 0 + cornerRadius ),
                        endAngle: Angle(degrees: 360 - cornerRadius ),
                        clockwise: false)
            
        }
    }
    
    
}
