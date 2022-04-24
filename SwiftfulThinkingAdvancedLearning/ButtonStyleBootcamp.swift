//
//  ButtonStyleBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 안민수 on 2022/04/24.
//

import SwiftUI

struct PressableButtonStyle : ButtonStyle {
    
    let scaledAmount: CGFloat
    
    init(scaledAmount: CGFloat = 0.9) {
        self.scaledAmount = scaledAmount}
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
//            .brightness(configuration.isPressed ? scaledAmount/4 : 0)
//            .opacity(configuration.isPressed ? 0.4 : 1.0)
    }
    
}

extension View {
    func withPressibleStyle(scaledAmount: CGFloat = 0.9) -> some View {
        self.buttonStyle(PressableButtonStyle(scaledAmount: scaledAmount))
    }
}

struct ButtonStyleBootcamp: View {
    var body: some View {
        
        VStack {
            Button {
                print("hi1 ")
            } label: {
                Text("Click Me")
                    .font(.headline)
                    .withDefaultButtonFormatting()
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0.0, y: 10)
            }
//            .buttonStyle(PressableButtonStyle())
            .withPressibleStyle()
            .padding(40)
            
            Button {
                print("hi2 ")
            } label: {
                Text("Click Me")
                    .font(.headline)
                    .withDefaultButtonFormatting(backgroundColor: .green)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0.0, y: 10)
            }
            .withPressibleStyle(scaledAmount: 0.4)
//            .buttonStyle(PressableButtonStyle(scaledAmount: 0.4))
            .padding(40)
            
        }

    }
}

struct ButtonStyleBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStyleBootcamp()
    }
}
