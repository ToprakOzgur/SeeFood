//
//  ViewController.swift
//  SeeFood
//
//  Created by Ozgur Toprak on 22/09/2017.
//  Copyright © 2017 Ozgur Toprak. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if  let userPickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
          imageView.image = userPickedimage
          
            guard   let ciimage = CIImage(image : userPickedimage) else  {
               
                fatalError("Could not convert to CIImage")
             
            }
            detect(image: ciimage)
        }
      
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage ) {
        guard let model = try?  VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed.")
            
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard    let results = request.results as? [VNClassificationObservation] else {
                
                fatalError("Model failed to process image")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog"){
                    
                    self.navigationItem.title = "Hotdog"
                } else {self.navigationItem.title = "Not Hot Dog"}
            }
        }
        
        let handler = VNImageRequestHandler(ciImage : image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

