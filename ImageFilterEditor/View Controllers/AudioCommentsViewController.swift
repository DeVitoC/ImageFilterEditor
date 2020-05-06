//
//  AudioCommentsViewController.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/5/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import AVFoundation

class AudioCommentsViewController: UIViewController {
    
    // MARK: - Properties
    var timer: Timer?
    var audioComments: [AudioComment]?
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    var audioPlayer: AVAudioPlayer?
    var recordingTime: Double = 0.00
    
    // MARK: - IBOutlets
    @IBOutlet weak var audioCommentsTableView: UITableView!
    @IBOutlet weak var recordingTimeLabel: UILabel!
    @IBOutlet weak var recordingSlider: UISlider!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func recordButtonTapped(_ sender: Any) {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    

    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: recordingTimeLabel.font.pointSize,
                                                          weight: .regular)
        updateViews()
        // TODO: do/try/catch error handling
        try? prepareAudioSession()
    }
    
    private func updateViews() {
        recordButton.isSelected = isRecording
        
        let currentTime = recordingTime
        if currentTime > 29.99 {
            stopRecording()
            recordingTimeLabel.text = "00:00"
            recordingSlider.value = 0
            cancelTimer()
            return
        }
        recordingTimeLabel.text = timeIntervalFormatter.string(from: currentTime) ?? "00:00"
        
        recordingSlider.minimumValue = 0
        recordingSlider.maximumValue = Float(30)
        recordingSlider.value = Float(currentTime)
    }
    
    deinit {
        cancelTimer()
    }
    
    // MARK: - Setup Methods
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(file)")
        
        return file
    }
    
    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need microphone access")
                    return
                }
                
                print("Recording permission has been granted!")
                // NOTE: Invite the user to tap record again, since we just interrupted them, and they may not have been ready to record
            }
        case .denied:
            print("Microphone access has been blocked.")
            
            let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        case .granted:
            startRecording()
        @unknown default:
            break
        }
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }
    
    // MARK: - Action Methods
    
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            self.recordingTime += 0.030
            self.updateViews()
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func startRecording() {
        let recordingURL = createNewRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try? AVAudioRecorder(url: recordingURL, format: format)
        // TODO: Error handling do/catch
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        self.recordingURL = recordingURL
        updateViews()
        
        startTimer()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
        cancelTimer()
    }
}

extension AudioCommentsViewController: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio record error: \(error)")
        }
        updateViews()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag,
            let recordingUrl = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingUrl)
        }
        updateViews()
    }
}

extension AudioCommentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        audioComments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = audioCommentsTableView.dequeueReusableCell(withIdentifier: "RecordingCell") as? AudioCommentTableViewCell,
            let audioComment = audioComments?[indexPath.row]
            else { return UITableViewCell() }
        
        cell.audioComment = audioComment
        
        return cell
    }
}
