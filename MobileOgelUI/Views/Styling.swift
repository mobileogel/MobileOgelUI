//
//  Styling.swift
//  MobileOgelUI
//
//  Created by Guy Morgenshtern on 2023-11-05.
//

import SwiftUI


struct TileViewModifier: ViewModifier { func body(content: Content) -> some View { content         .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        //.background(Color(red: 0.89, green: 0.937, blue: 1.0))
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}
