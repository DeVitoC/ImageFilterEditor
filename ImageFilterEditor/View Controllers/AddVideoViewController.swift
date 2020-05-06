//
//  AddVideoViewController.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/6/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import AVFoundation

class AddVideoViewController: UIViewController {
    
    // MARK: - Properties
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    private var player: AVPlayer!
    private let playerView = VideoPlayerView()
    
    // MARK: - IBOutlets
    @IBOutlet var videoPreviewView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func recordButtonTapped(_ sender: Any) {
        toggleRecord()
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        //videoPreviewView.videoPlayerView.videoGravity = .resizeAspectFill
        //setUpCaptureSession()
        view.addSubview(playerView)
        playMovie(url: Bundle.main.url(forResource: "357421238", withExtension: "mp4")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    // MARK: - Setup Methods
    private func setUpCaptureSession() {
        captureSession.beginConfiguration()
        let camera = bestCamera()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput) else {
                fatalError("Error adding camera to capture session.")
        }
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        // Microphone input
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Error: Cannot save movie with capture session.")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        videoPreviewView.session = captureSession
        // TODO: Start/Stop Session
    }
    
    private func bestCamera() -> AVCaptureDevice {
        // Ultra-wide lens (iPhone 11 Pro Max and iPhone 11 Pro on back)
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return ultraWideCamera
        }
        // Wide angle lens (available on any iPhone - front/back)
        if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return wideAngleCamera
        }
        // No camera present (simulator)
        fatalError("No camera available - are you on a simulator?")
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    // MARK: - Action Methods
    private func toggleRecord() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    private func playMovie(url: URL) {
        player = AVPlayer(url: url)
        playerView.player = player
        // top left corner (Fullscreen, you'd need a close button)
        var topRect = view.bounds
        topRect.size.height = topRect.size.height / 2
        topRect.size.width = topRect.size.width / 2 // create a constant for the "magic number"
        //topRect.origin.y = view.layoutMargins.top
        topRect.origin.y = view.bounds.height/2 - topRect.size.height/2
        topRect.origin.x = view.bounds.width/2 - topRect.size.width/2
        playerView.frame = topRect
        // FIXME: Don't add every time we play
        player.play()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension AddVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        updateViews()
        if let error = error {
            print("Error saving video: \(error)")
        } else {
            // show movie
            playMovie(url: outputFileURL)
            
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("Started Recording: \(fileURL)")
        updateViews()
        
    }
}
