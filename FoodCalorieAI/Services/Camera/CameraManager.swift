//
//  CameraManager.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 08.03.2026.
//

import AVFoundation
import UIKit
import SwiftUI

class CameraManager: NSObject, ObservableObject {
    
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var device: AVCaptureDevice?
    
    private var completion: ((UIImage?) -> Void)?
    
    @Published var imageName = ""
    @Published var image: UIImage?
    
    @Published var flashOn = false
    @Published var isLoading = false
    
    private var isConfigured = false
    
    
    func setup() {
        guard !isConfigured else { return }
        isConfigured = true
        
        session.beginConfiguration()
        
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else { return }
        
        device = camera
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
    }
    
    
    func start() {
        checkPermissionAndStart()
    }
    
    func stop() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    func checkPermissionAndStart() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setup()
            session.startRunning()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setup()
                        self.session.startRunning()
                    }
                }
            }
            
        default:
            break
        }
    }
    
    
    func takePhoto(completion: @escaping (UIImage?) -> Void) {
        
        self.completion = completion
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flashOn ? .on : .off
        
        output.capturePhoto(with: settings, delegate: self)
        
    }
    
    
    func toggleFlash() {
        flashOn.toggle()
    }
}


extension CameraManager: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard
            let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data)
        else {
            completion?(nil)
            return
        }
        
        completion?(image)
    }
}
