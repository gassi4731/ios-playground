//
//  DocumentPickerViewController.swift
//  Sample
//
//  Created by Yo Higashida on 2023/01/11.
//

import UIKit
import UniformTypeIdentifiers

class DocumentPickerViewController: UIViewController {
    
    var musicUrls: [URL] = []
    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectMusics() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func play() {
        guard musicUrls.count == 0 else { return }
    }
    
    @IBAction func stop() {
        
    }
}

extension DocumentPickerViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // ファイル選択後に呼ばれる
        // urls.first?.pathExtensionで選択した拡張子が取得できる

        if let filePath = urls.first?.description {
            musicUrls.append(urls.first!)
            print("ファイルパス:\(filePath)")
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("キャンセル")
    }
}
