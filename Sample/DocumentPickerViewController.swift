//
//  DocumentPickerViewController.swift
//  Sample
//
//  Created by Yo Higashida on 2023/01/11.
//

import UIKit
import AVFoundation
import UniformTypeIdentifiers

class DocumentPickerViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var currentMusicIndex: Int = 0
    
    var musicUrls: [URL] = []
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func application (_ application: UIApplication, didFinishLaunchingWithOptionslaunchOption:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(.playback, mode: .default)
        }catch{
            fatalError("session有効化失敗")
        }
        return true
    }
    
    @IBAction func selectMusics() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func play() {
        guard musicUrls.count != 0 else { return } // もし登録件数が0件だった場合実行しない
        
        playSound(url: musicUrls[currentMusicIndex])
    }
    
    @IBAction func stop() {
        playStop(url: musicUrls[currentMusicIndex])
    }
}

// MARK: UIDocumentPickerDelegate
extension DocumentPickerViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // ファイル選択後に呼ばれる
        if let filePath = urls.first?.description {
            musicUrls.append(urls.first!)
            textView.text = musicUrls.map{ $0.description }.joined(separator: "\n")
            print("ファイルパス:\(filePath)")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("キャンセル")
    }
}

// MARK: AVAudioPlayerDelegate
extension DocumentPickerViewController: AVAudioPlayerDelegate {
    
    func playSound(url: URL){
        // ファイルのセキリュティ保護を解除
        guard url.startAccessingSecurityScopedResource() else { return }
        
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.delegate = self
        audioPlayer.play()
    }
    
    func playStop(url: URL) {
        audioPlayer.stop()
        do { url.stopAccessingSecurityScopedResource() }
    }
}
