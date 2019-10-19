//
//  SelectViewController.swift
//  Example
//
//  Created by Yuiga Wada on 2019/10/19.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private weak var cameraPicker: UIImagePickerController?
    
    @IBAction func launchImagePicker(_ sender: Any) {
//        let imagePicker = UIImagePickerController()
//
//        self.present(imagePicker, animated: true, completion: nil)
        
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            self.cameraPicker = UIImagePickerController()
            self.cameraPicker?.sourceType = sourceType
            self.cameraPicker?.delegate = self
            self.present(self.cameraPicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
//            cameraView.contentMode = .scaleAspectFit
//            cameraView.image = pickedImage
        }
        self.cameraPicker?.dismiss(animated: true, completion: nil)
    }
}
