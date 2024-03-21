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
        VStack {
            if let capturedImage = viewModel.capturedImage {
                Image(uiImage: capturedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(drawingView)
            } else {
                Text("No image available")
            }
            NavButton(destination: PieceInventoryView(), title:"See Piece List" , width: 200, cornerRadius: 25)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SharedDataDidChange"))) { _ in
            // Handle data change
            viewModel.handleDataChange()
        }
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

    var body: some View {
        let boundingBox = observation.boundingBox
        let scaledBoundingBox = CGRect(
            x: boundingBox.origin.x * imageSize.width,
            y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height,
            width: boundingBox.width * imageSize.width,
            height: boundingBox.height * imageSize.height
        )

        return RoundedRectangle(cornerRadius: 5)
            .stroke(Color.red, lineWidth: 2)
            .frame(width: scaledBoundingBox.width, height: scaledBoundingBox.height)
            .position(x: scaledBoundingBox.midX, y: scaledBoundingBox.midY)
    }
}
