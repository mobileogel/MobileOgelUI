//
//  LibraryView.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar on 2023-11-03.
//

import SwiftUI

struct LibraryView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        
        VStack {
            HStack{
                Text("Library")
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading)
                Spacer()
                Image(systemName: "house.fill")
                    .font(.largeTitle)
                    .padding(.trailing)
                    .onTapGesture {
                        // go to home page
                    }
            }
            .padding(.top)
                //perhaps we can do something like this
                Picker("", selection: $selectedTab) {
                    Text("Perfect Match").tag(0)
                    Text("Similar Match").tag(1)
                    Text("All").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())

                /*switch(selectedTab) {
                    case 0: FirstTabView() -> we need to implement this function to display stuff accordingly
                    case 1: SecondTabView()
                    case 2: ThirdTabView()
                }*/
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
