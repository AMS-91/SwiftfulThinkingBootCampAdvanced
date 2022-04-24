//
//  ViewModifierBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 안민수 on 2022/04/24.
//

import SwiftUI

struct DefaultButtonViewModifier: ViewModifier {
    
    let backgroundColor : Color
    
    func body(content: Content) -> some View {
                    content
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(backgroundColor)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding()
    }
}

extension View {
    
    func withDefaultButtonFormatting(backgroundColor: Color = .gray) -> some View {
        modifier(DefaultButtonViewModifier(backgroundColor: backgroundColor))
    }
    
}

struct ViewModifierBootcamp: View {
    
    
    
    var body: some View {
        VStack {
            
            Text("Hello World!")
                .withDefaultButtonFormatting(backgroundColor: .blue)
//                .modifier(DefaultButtonViewModifier())

            Text("Hello everyone!")
                .modifier(DefaultButtonViewModifier(backgroundColor: .green))

            
            Text("Hello!!")
                .modifier(DefaultButtonViewModifier(backgroundColor: .yellow))
        }
    }
}

struct ViewModifierBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ViewModifierBootcamp()
    }
}
