//
//  ImageViewController.swift
//  mosaic
//
//  Created by Wilson Ding on 10/22/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices
import Alamofire
import SwiftyJSON

class ImageViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var preTranslateText: UIButton!
    @IBOutlet weak var postTranslateText: UIButton!
    
    let mySynthesizer = AVSpeechSynthesizer()

    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    let cognitiveServices = CognitiveServices.sharedInstance
    
    var checkTimer: Timer!
    
    var sourceSpeakingLanguage: String!
    var targetSpeakingLanguage: String!
    var iOSSpeakingLanguage: String!
    var iOSOriginalLanguage: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = colorWithHexString(hex: "011A46")
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        preTranslateText.fadeOut()
        postTranslateText.fadeOut()
        
        preTranslateText.fadeIn()
        postTranslateText.fadeIn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPreset352x288
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        var error: Error?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewView.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
                
                self.checkTimer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.takePhoto), userInfo: nil, repeats: true)
            }
        }
        
        sourceSpeakingLanguage = PreferenceCriteria.sharedInstance.sourceSpeakingLanguage
        print(sourceSpeakingLanguage)
        targetSpeakingLanguage = PreferenceCriteria.sharedInstance.targetSpeakingLanguage
        iOSSpeakingLanguage = PreferenceCriteria.sharedInstance.iOSSpeakingLanguage
        iOSOriginalLanguage = PreferenceCriteria.sharedInstance.iOSOriginalLanguage
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession!.stopRunning()
        self.checkTimer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    
    func takePhoto() {
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    
                    self.analyzeImage(image: image)
                }
            })
        }
    }
    
    func analyzeImage(image: UIImage) {
        let analyzeImage = CognitiveServices.sharedInstance.analyzeImage
        
        let visualFeatures: [AnalyzeImage.AnalyzeImageVisualFeatures] = [.Categories, .Description, .ImageType, .Color, .Adult]
        let requestObject: AnalyzeImageRequestObject = (image, visualFeatures)
        
        try! analyzeImage.analyzeImageWithRequestObject(requestObject, completion: { (response) in
            DispatchQueue.main.async(execute: {
                if response != nil {
                    if response!.descriptionText != nil {
                        var resultOfMicrosoft = String(response!.descriptionText!)!
                        
                        
                        if (self.targetSpeakingLanguage=="en") {
                            self.postTranslateText.setTitle(response!.descriptionText!, for: .normal)
                        } else {
                            resultOfMicrosoft = resultOfMicrosoft.replacingOccurrences(of: " ", with: "%20")
                            let query1 = "https://www.googleapis.com/language/translate/v2?key=AIzaSyC2CiPuqHW-RQYuAMjJKu4-CXDAz_NkDnc&q=\(resultOfMicrosoft)&source=en&target=\(self.targetSpeakingLanguage!)"
                            self.getAlamofireRequest(url: query1, button: self.postTranslateText)
                        }
                        if (self.sourceSpeakingLanguage=="en") {
                            self.preTranslateText.setTitle(response!.descriptionText!, for: .normal)
                        } else {
                            resultOfMicrosoft = resultOfMicrosoft.replacingOccurrences(of: " ", with: "%20")
                            let query2 = "https://www.googleapis.com/language/translate/v2?key=AIzaSyC2CiPuqHW-RQYuAMjJKu4-CXDAz_NkDnc&q=\(resultOfMicrosoft)&source=en&target=\(self.sourceSpeakingLanguage!)"
                            self.getAlamofireRequest(url: query2, button: self.preTranslateText)
                        }
                    }
                }
            })
        })
    }
    
    @IBAction func preTranslateTextButtonPressed(_ sender: AnyObject) {
        self.playTranslation(data: preTranslateText.currentTitle!, target: "\(self.iOSOriginalLanguage!)")
    }
    
    @IBAction func postTranslateTextButtonPressed(_ sender: AnyObject) {
        self.playTranslation(data: postTranslateText.currentTitle!, target: "\(self.iOSSpeakingLanguage!)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuOptions" {
            if segue.destination is LanguageSelectionViewController {
                
                PreferenceCriteria.sharedInstance.sourceSpeakingLanguage = sourceSpeakingLanguage
                PreferenceCriteria.sharedInstance.targetSpeakingLanguage = targetSpeakingLanguage
                PreferenceCriteria.sharedInstance.iOSSpeakingLanguage = iOSSpeakingLanguage
                PreferenceCriteria.sharedInstance.iOSOriginalLanguage = iOSOriginalLanguage
                
            }
        }
    }
}



extension ImageViewController {
    func getAlamofireRequest(url: String, button: UIButton) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let translate = String(describing: json["data"]["translations"][0]["translatedText"])
                button.setTitle(translate, for: .normal)
            //  print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func playTranslation(data: String, target: String) {
        let myUtterence = AVSpeechUtterance(string: data)
        myUtterence.rate = AVSpeechUtteranceDefaultSpeechRate
        myUtterence.voice = AVSpeechSynthesisVoice(language: target)
        myUtterence.pitchMultiplier = 1
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch let error as NSError {
            print("Error: Could not set audio category: \(error), \(error.userInfo)")
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            print("Error: Could not setActive to true: \(error), \(error.userInfo)")
        }
        
        mySynthesizer.speak(myUtterence)
    }
}

extension ImageViewController {
    // Creates a UIColor from a Hex string.
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
}
