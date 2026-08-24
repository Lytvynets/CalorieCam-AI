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
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private var completion: ((UIImage?) -> Void)?
    private var isConfigured = false
    
    @Published var imageName = ""
    @Published var image: UIImage?
    @Published var flashOn = false
    @Published var isLoading = false
    
    
    func setup() {
        guard !isConfigured else { return }
        isConfigured = true
        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            session.commitConfiguration()
            return
        }

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
            sessionQueue.async {
                self.setup()
                self.session.startRunning()
            }

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else { return }

                self.sessionQueue.async {
                    self.setup()
                    self.session.startRunning()
                }
            }

        default:
            break
        }
    }
    
    
    func takePhoto(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
        let settings = AVCapturePhotoSettings()
        if output.supportedFlashModes.contains(flashOn ? .on : .off) {
            settings.flashMode = flashOn ? .on : .off
        }

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
        if let error = error {
            print("Photo error:", error)
            completion?(nil)
            return
        }

        guard let data = photo.fileDataRepresentation() else {
            print("fileDataRepresentation() == nil")
            completion?(nil)
            return
        }

        let image = UIImage(data: data)
        completion?(image)
    }
}
