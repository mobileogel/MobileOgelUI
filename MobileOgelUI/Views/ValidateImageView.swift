//
//  ValidateImageView.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar on 2023-11-03.
//

import SwiftUI

struct ValidateImageView: View {
    var body: some View {
        VStack{
            
            Text("Review")
                .font(.largeTitle)
                .bold()
            
            Rectangle()
                .frame(width: 300, height: 500)
                .padding(40)
            
            HStack (spacing: 50){
                Button(action: {
                    // Action for the third button
                    // Add your code here
                }) {
                    Text("Retake")
                        .bold()
                        .foregroundColor(.black)
                        .padding(20)
                        .font(.title)
                }
                .background(Color.green)
                .cornerRadius(20)
                
                Button(action: {
                    // Action for the third button
                    // Add your code here
                }) {
                    Text("Proceed")
                        .bold()
                        .foregroundColor(.black)
                        .padding(20)
                        .font(.title)
                }
                .background(Color.green)
                .cornerRadius(20)
            }
        }
    }
}

struct ValidateImageView_Previews: PreviewProvider {
    static var previews: some View {
        ValidateImageView()
    }
}
