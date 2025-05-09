//
//  ContentView.swift
//  CoreMLLabel101
//
//  Created by Gabriel Sabaini on 24/04/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var classificationLabel: String = ""
    @State var pickerImage: PhotosPickerItem?
    @State var selectedImage: UIImage?
    
    var coreMLViewModel: CoreMLViewModel = CoreMLViewModel()
    
    var body: some View {
        VStack {
            PhotosPicker("Coloque sua Imagem aqui!", selection: $pickerImage, matching: .images)
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .frame(width: 250, height: 250)
                    .scaledToFill()
                Text(classificationLabel)
            }
        }
        .padding()
        .onChange(of: pickerImage) { oldValue, newValue in
            Task {
                guard let imageData = try await pickerImage?.loadTransferable(type: Data.self) else { return }
                guard let inputImage = UIImage(data: imageData) else { return }
                selectedImage = inputImage
                classificationLabel = coreMLViewModel.checkImage(selectedImage!)
                
            }
        }
    }
}

#Preview {
    ContentView()
}
