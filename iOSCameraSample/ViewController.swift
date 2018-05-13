//
//  ViewController.swift
//  iOSCameraSample
//
//  Created by mn(D128) on 2018/05/12.
//  Copyright © 2018年 mn(D128). All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var debugView: DebugView!
    
    private let session: AVCaptureSession = AVCaptureSession()
    
    private var metadataFaceObjects: [AVMetadataFaceObject] = [AVMetadataFaceObject]()
    private var captureImage: UIImage?
    
    // MAKR: - UIViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let completionHandler: (AVAuthorizationStatus) -> Void = { [weak self] status in
            switch status {
            case .authorized:
                self?.start()
                
            case .notDetermined, .denied, .restricted:
                // ユーザーへ表示
                break
            }
        }
        
        self.requestAccess(for: AVMediaType.video,
                           completionHandler: completionHandler)
    }
    
    // MARK: - Private
    
    private func requestAccess(for mediaType: AVMediaType,
                               completionHandler handler: @escaping (AVAuthorizationStatus) -> Void) {
        let completionHandler: (Bool) -> Void = { result in
            let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
            DispatchQueue.main.async {
                handler(status)
            }
        }
        
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        case .authorized, .denied, .restricted:
            // OK、OFF、機能制限
            DispatchQueue.main.async {
                handler(status)
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: completionHandler)
        }
    }
    
    private func start() {
        /* AVCaptureDevice.DeviceType */
        
        // builtInTelephotoCamera
        //   広角カメラよりも焦点距離が長い内蔵カメラデバイス。
        
        // builtInWideAngleCamera
        //   内蔵の広角カメラ。 これらのデバイスは汎用用途に適しています。
        
        // builtInDualCamera
        //   ズーム機能とデュアル画像キャプチャ機能を強化し、写真、ビデオ、
        //   デプスキャプチャが可能なキャプチャデバイスを作成する広角カメラと望遠カメラの組み合わせ。
        
        // builtInTrueDepthCamera
        //   写真やビデオ、奥行きのキャプチャが可能なキャプチャデバイスを作成するカメラと他のセンサの組み合わせ。
        
        // builtInMicrophone
        //   内蔵マイク
        
        guard let videoDevice: AVCaptureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                                         for: AVMediaType.video,
                                                                         position: AVCaptureDevice.Position.front) else {
                                                                            return
        }
        
        guard let captureDeviceInput: AVCaptureDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }
        
        if !self.session.canAddInput(captureDeviceInput) {
            return
        }
        
        self.session.addInput(captureDeviceInput)
        
        let captureVideoDataOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
        if !self.session.canAddOutput(captureVideoDataOutput) {
            return
        }

        self.session.addOutput(captureVideoDataOutput)
        
        if let connection: AVCaptureConnection = captureVideoDataOutput.connections.first {
            // カメラ映像の回転状態を調整（デフォルトは横になってる）
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = AVCaptureVideoOrientation.portrait
            }
            
            // フロントカメラ映像の左右反転を調整（デフォルトは反転している）
            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = true
            }
        }
        
//        case userInteractive
//        case userInitiated
//        case default 同義：DispatchQueue.global()
//        case utility
//        case background
//        case unspecified
        
        captureVideoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .default))
        
        // captureVideoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String : Int(kCVPixelFormatType_32BGRA)]
        
        // キューがブロックされているときに新しいフレームが来たら削除.
        captureVideoDataOutput.alwaysDiscardsLateVideoFrames = true
        
        // 顔を認識
        let captureMetadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        if !self.session.canAddOutput(captureMetadataOutput) {
            return
        }
        
        self.session.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.face]
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.global(qos: .default))
        
//        do {
//            try videoDevice.lockForConfiguration()
//            // フレームレート
//            videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, 30)
//            videoDevice.unlockForConfiguration()
//        } catch _ {
//            print("aaaaaa")
//        }
        
        self.session.startRunning()
    }

}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let image: UIImage = sampleBuffer.image(0.0) else {
            return
        }
        
        let faces: [DLBFace] = DLBWrapper.shared().detectFaces(image,
                                                               metadataFaceObjects: self.metadataFaceObjects)
        
        self.captureImage = image
        
        DispatchQueue.main.sync { [weak self] in
            self?.imageView.image = image
            self?.debugView.imageSize = image.size
            self?.debugView.faces = faces
        }
    }
    
}

extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        var metadataFaceObjects: [AVMetadataFaceObject] = [AVMetadataFaceObject]()
        
        for metadataObject in metadataObjects {
            guard let metadataFaceObject: AVMetadataFaceObject = metadataObject as? AVMetadataFaceObject else {
                continue
            }
            
            metadataFaceObjects.append(metadataFaceObject)
        }
        
        var faces: [DLBFace] = [DLBFace]()
        if let captureImage: UIImage = self.captureImage {
            faces = DLBWrapper.shared().detectFaces(captureImage,
                                                    metadataFaceObjects: metadataFaceObjects)
        }

        DispatchQueue.main.sync { [weak self] in
            self?.debugView.faces = faces
        }
        
        self.metadataFaceObjects = metadataFaceObjects
        
    }
    
}

