//
//  DetectionView.swift
//  MobileOgelUI
//
//  Created by Guy Morgenshtern on 2024-03-14.
//

import SwiftUI
import Vision

struct DetectionView: View {
    @ObservedObject var viewModel = DetectionViewModel()

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Captured Image")
                .font(.largeTitle)
                .foregroundStyle(.black)
                .bold()
                .padding(.top, 20)
            
            // display image based on screen size
            if let capturedImage = viewModel.capturedImage {
                GeometryReader { geometry in
                    Image(uiImage: capturedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(drawingView)
                        .coordinateSpace(name: "image")
                }
            } else {
                Text("No image available")
            }
            
            NavButton(destination: PieceInventoryView(), title:"My Pieces" , width: 200, cornerRadius: 25)
            
            
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name("SharedDataDidChange"))) { _ in
            // Handle data change
            viewModel.handleDataChange()
        }.background(Color(red: 0.961, green: 0.961, blue: 0.961))
    }

    var drawingView: some View {
        GeometryReader { geometry in
            ForEach(viewModel.detections ?? [], id: \.self) { observation in
                BoundingBoxView(observation: observation, imageSize: geometry.size)
            }
        }
    }
}

struct BoundingBoxView: View {
    let observation: VNRecognizedObjectObservation
    let imageSize: CGSize
    @State private var showText = false

    var body: some View {
        let boundingBox = observation.boundingBox
        let scaledBoundingBox = CGRect(
            x: boundingBox.origin.x * imageSize.width,
            y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height,
            width: boundingBox.width * imageSize.width,
            height: boundingBox.height * imageSize.height
        )

        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.red, lineWidth: 2)
                .frame(width: scaledBoundingBox.width, height: scaledBoundingBox.height)
                .position(x: scaledBoundingBox.midX, y: scaledBoundingBox.midY)
                .onTapGesture {
                    self.showText.toggle()
                }

            if showText {
                Text(observation.labels.first?.identifier ?? "unknown piece")
                    .foregroundColor(.white)
                    .background(Color.black)
                    .padding(5)
                    .offset(y: -30)
                    .position(x: scaledBoundingBox.midX, y: scaledBoundingBox.minY - 15)
            }
        }
    }
}
