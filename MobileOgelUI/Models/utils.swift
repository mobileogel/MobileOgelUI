//
//  utils.swift
//  MobileOgelUI
//
//  Created by Guy Morgenshtern on 2024-01-19.
//

import UIKit


class Util {
    static func getImageNameOrPlaceHolder(withX value: String) -> String {
       
        if let piece = UIImage(named: value) {
            return value
            
        } else {
            
            let components = value.components(separatedBy: "_")

            if let firstPart = components.first {
                let placeHolder = firstPart.appending("_placeholder")
                
                if let placeholderImage = UIImage(named: placeHolder) {
                    return placeHolder
                } else {
                    return "missing_pieces_icon"
                }
                
            } else {
                return "missing_pieces_icon"
            }
        }
    }
    
    static func resizeImageToModelStandard(image: UIImage) -> UIImage?{
        let targetSize = CGSize(width: 640, height: 640)
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(origin: .zero, size: newSize)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }


}

extension UIImage {
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}
