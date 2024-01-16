//
//  NavButton.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-01-15.
//

import SwiftUI

struct NavButton<Destination: View>: View {
    let destination: Destination
    let title: LocalizedStringResource
    let width: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        NavigationLink(
            destination: destination.navigationBarBackButtonHidden(true),
            label: {
                Text(title)
                    .bold()
                    .foregroundColor(.black)
                    .font(.title3)
                    .padding(EdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12))
                    .frame(maxWidth: width)
            })
        .background(Color(red: 0.859, green: 0.929, blue: 0.702))
        .cornerRadius(cornerRadius)
    }
}

#Preview {
    NavButton(destination: EmptyView(), title: "Example", width: 200, cornerRadius: 20)
}
