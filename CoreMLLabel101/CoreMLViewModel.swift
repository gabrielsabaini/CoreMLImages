//
//  CoreMLViewModel.swift
//  CoreMLLabel101
//
//  Created by Gabriel Sabaini on 24/04/25.
//

import CoreML
import Vision
import SwiftUI

/// Class that have the CoreML functions
///
/// Class that relates CoreML with Views
class CoreMLViewModel {
    
    /// Check Image and uses the CoreML model
    ///
    ///  - Parameters:
    ///     - image: The image that will be analyzed
    ///
    ///  - Returns: A String with the strong classification of the image in the model
    func checkImage(_ image: UIImage) -> String {
        guard let ciImage = CIImage(image: image) else {
            print("Could not convert UIImage to CIImage.")
            exit(0)
        }

        var classificationLabel: String = ""
        
        do {
            let config = MLModelConfiguration()
            let model = try VNCoreMLModel(for: DogOrCat(configuration: config).model)
            
            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation] {
                    classificationLabel = results.first!.identifier
                } else {
                    print("Invalid Classify")
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            try handler.perform([request])
            
        } catch {
            print("Could not load model: \(error.localizedDescription)")
        }
        return classificationLabel
    }
}
