//
//  QRScannerViewController.swift
//  reko
//
//  Created by Brian Lin on 9/8/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit
import Vision
import AVKit

class QRScannerViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    private var session = AVCaptureSession()
    private let visionQueue = DispatchQueue(label: "com.brianlin.seko_qr")
    private var requests = [VNRequest]()
    private var foundResult = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startLiveVideo()
        startTextDetection()
    }
    
    override func viewDidLayoutSubviews() {
        imgView.layer.sublayers?[0].frame = imgView.bounds
    }
    
    func startLiveVideo() {
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.frame = imgView.bounds
        imgView.layer.addSublayer(imageLayer)
        
        session.startRunning()
    }
    
    func startTextDetection() {
        let qrRequest = VNDetectBarcodesRequest(completionHandler: self.detectTextHandler)
        self.requests = [qrRequest]
    }
    
    func detectTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results else {
            print("no result")
            return
        }
        
        if observations.count > 0 && !foundResult {
            foundResult = true
            let ob = observations.first as? VNBarcodeObservation
            
            if let payload = ob!.payloadStringValue {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                addMask()
                matchFound()
                print(payload)
            }
        }
    }

    private func addMask() {
        DispatchQueue.main.async {
            let mask = UIView()
            mask.backgroundColor = .white
            self.view.addSubview(mask)
        }
       
    }
    
    private func matchFound() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            let navigationController = UINavigationController(rootViewController: RecruiterViewController())
            self.present(navigationController, animated: true, completion: nil)
        })
    }
}

extension QRScannerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .down, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}
