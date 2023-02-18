//
//  ImageTaker.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.02.2023.
//

import Foundation
import SwiftUI

struct ImageTaker: UIViewControllerRepresentable{
    @Binding var takedImage: UIImage?
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
        let parent: ImageTaker
        
        init(_ parent: ImageTaker){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.editedImage] as? UIImage{
                self.parent.takedImage = image
            }
        }
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imageTaker = UIImagePickerController()
        imageTaker.sourceType = .camera
        imageTaker.cameraCaptureMode = .photo
        imageTaker.allowsEditing = true
        imageTaker.delegate = context.coordinator
        return imageTaker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
}
