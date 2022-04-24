//
//  AnyTransitionBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 안민수 on 2022/04/24.
//

import SwiftUI

struct RotateViewModifier: ViewModifier {
    
    let rotation : Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotation))
            .offset(
                x: rotation != 0 ? UIScreen.main.bounds.width : 0,
                y: rotation != 0 ? UIScreen.main.bounds.height : 0
            )
    }
}


extension AnyTransition {
    
    static var rotating: AnyTransition {
//        return AnyTransition.modifier(
//      return 과 AnyTransition. 없어도 자동으로 추적해줌.
        modifier(
            active: RotateViewModifier(rotation: 180),
            identity: RotateViewModifier(rotation: 0)
        )
    }
    
    static func rotating(rotation: Double) -> AnyTransition {
        return AnyTransition.modifier(
            active: RotateViewModifier(rotation: rotation),
            identity: RotateViewModifier(rotation: 0)
        )
    }
    
    static var rotateOn: AnyTransition {
        return AnyTransition.asymmetric(
            insertion: .rotating,
            removal: .move(edge: .leading)
        )
    }
    
}


struct AnyTransitionBootcamp: View {
    
    @State private var showRectangle: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            if showRectangle {
                
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width:250, height: 350)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.rotateOn)
//                .transition(.rotating(rotation: 1080))
//                .transition(AnyTransition.rotating.animation(.easeInOut))
            
            }
            
            Spacer()
            
            Text("Click Me!")
                .withDefaultButtonFormatting()
                .padding(.horizontal, 40)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        showRectangle.toggle()
                    }
                }
        
        }
    }
}

struct AnyTransitionBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AnyTransitionBootcamp()
    }
}
