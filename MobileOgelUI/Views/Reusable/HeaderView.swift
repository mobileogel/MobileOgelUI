//
//  HeaderView.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-03-13.
//

import SwiftUI

struct HeaderView: View {
    let title: LocalizedStringResource
    
    var body: some View {
        HStack{
            Text(title)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.black)
                .padding(.leading)
            Spacer()
            
            NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true)) {
                Image(systemName: "house.fill")
                    .font(.largeTitle)
                    .padding(.trailing)
                    .foregroundColor(.black)
            }
        }
        .padding(.top)
    }
}

#Preview {
    HeaderView(title: "Header")
}
