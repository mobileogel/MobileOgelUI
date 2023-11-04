//
//  ValidateImageView.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar on 2023-11-03.
//

import SwiftUI

struct ValidateImageView: View {
    var body: some View {
        NavigationStack{
            VStack{
                
                Text("Review")
                    .font(.largeTitle)
                    .bold()
                
                //Captured image goes here
                Rectangle()
                    .frame(width: 300, height: 500)
                    .padding(40)
                
                HStack (spacing: 50){
                    NavButton(destination: MainView(), title: "Retake", width: 150, cornerRadius: 10)
                    NavButton(destination: PieceInventoryView(), title: "Proceed", width: 150, cornerRadius: 10)
                }
            }
        }
    }
}

struct ValidateImageView_Previews: PreviewProvider {
    static var previews: some View {
        ValidateImageView()
    }
}
