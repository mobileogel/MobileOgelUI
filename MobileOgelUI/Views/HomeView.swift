//
//  HomeView.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar on 2023-11-03.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack{
            Color(red: 0.70, green: 0.84, blue: 1.0)
            VStack {
                
                Text("HOME")
                    .bold()
                    .font(.largeTitle)
                
                Button(action: {
                    // Action for the first button
                    // Add your code here
                }) {
                    Text("Scan")
                        .bold()
                        .foregroundColor(.black)
                        .font(.title)
                        .padding(30)
                        .frame(width: 300, height: 100)
                }
                .background(Color.blue)
                .cornerRadius(20)
                
                Button(action: {
                    // Action for the second button
                    // Add your code here
                }) {
                    Text("My Pieces")
                        .bold()
                        .foregroundColor(.black)
                        .font(.title)
                        .padding(30)
                        .frame(width: 300, height: 100)
                }
                .background(Color.red)
                .cornerRadius(20)
                

                Button(action: {
                    // Action for the third button
                    // Add your code here
                }) {
                    Text("Library")
                        .bold()
                        .foregroundColor(.black)
                        .padding(30)
                        .font(.title)
                        .frame(width: 300, height: 100)
                }
                .background(Color.green)
                .cornerRadius(20)
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
        
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
