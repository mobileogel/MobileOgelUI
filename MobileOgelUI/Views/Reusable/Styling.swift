//
//  Styling.swift
//  MobileOgelUI
//
//  Contributers: Guy Morgenshtern and Shuvaethy Neill
//

import SwiftUI


struct TileViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        //.background(Color(red: 0.89, green: 0.937, blue: 1.0))
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 3)
    }
}

struct ButtonTextModifier: ViewModifier {
    let width: CGFloat
    
    func body(content: Content) -> some View {
        content
            .bold()
            .foregroundColor(.black)
            .font(.title3)
            .padding(EdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12))
            .frame(maxWidth: width)
    }
}

struct ButtonModifier: ViewModifier {
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(Color(red: 0.859, green: 0.929, blue: 0.702))
            .cornerRadius(cornerRadius)
    }
}

