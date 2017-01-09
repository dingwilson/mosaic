//
//  LanguageSelectionViewController.swift
//  mosaic
//
//  Created by Wilson Ding on 10/23/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit


class LanguageSelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var myPicker: UIPickerView!
    
    var sourceSpeakingLanguage: String = PreferenceCriteria.sharedInstance.sourceSpeakingLanguage
    var targetSpeakingLanguage: String = PreferenceCriteria.sharedInstance.targetSpeakingLanguage
    var iOSSpeakingLanguage: String = PreferenceCriteria.sharedInstance.iOSSpeakingLanguage
    var iOSOriginalLanguage: String = PreferenceCriteria.sharedInstance.iOSOriginalLanguage
    
    let pickerData = [
        ["Arabic",
         "Chinese",
         "Czech",
         "Danish",
         "Dutch",
         "English",
         "Finnish",
         "French",
         "German",
         "Greek",
         "Hindi",
         "Hungarian",
         "Indonesian",
         "Italian",
         "Japanese",
         "Korean",
         "Norwegian",
         "Polish",
         "Portuguese",
         "Romanian",
         "Russian",
         "Slovak",
         "Spanish",
         "Thai",
         "Turkish"],
        ["Arabic",
         "Chinese",
          "Czech",
          "Danish",
          "Dutch",
          "English",
          "Finnish",
          "French",
          "German",
          "Greek",
          "Hindi",
          "Hungarian",
          "Indonesian",
          "Italian",
          "Japanese",
          "Korean",
          "Norwegian",
          "Polish",
          "Portuguese",
          "Romanian",
          "Russian",
          "Slovak",
          "Spanish",
          "Thai",
          "Turkish"]
    ]
    
    let targetCountriesData = ["ar-SA",
                               "zh-CN",
                               "cs-CZ",
                               "da-DK",
                               "nl-BE",
                               "en-US",
                               "fi-FI",
                               "fr-FR",
                               "de-DE",
                               "el-GR",
                               "hi-IN",
                               "hu-HU",
                               "id-ID",
                               "it-IT",
                               "ja-JP",
                               "ko-KR",
                               "no-NO",
                               "pl-PL",
                               "pt-PT",
                               "ro-RO",
                               "ru-RU",
                               "sk-SK",
                               "es-MX",
                               "th-TH",
                               "tr-TR"]
    
    let sourceCountriesData = ["ar",
                               "zh-CN",
                               "cs",
                               "da",
                               "nl",
                               "en",
                               "fi",
                               "fr",
                               "de",
                               "el",
                               "hi",
                               "hu",
                               "id",
                               "it",
                               "ja",
                               "ko",
                               "no",
                               "pl",
                               "pt",
                               "ro",
                               "ru",
                               "sk",
                               "es",
                               "th",
                               "tr"]
    
    let source = 0
    let target = 1
    
    //MARK: - Picker View Data Sources and Delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_
        pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int
        ) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_
        pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int)
    {
        updateLabel()
    }
    
    func updateLabel(){
        self.sourceSpeakingLanguage = sourceCountriesData[myPicker.selectedRow(inComponent: source)]
        self.targetSpeakingLanguage = sourceCountriesData[myPicker.selectedRow(inComponent: target)]
        self.iOSSpeakingLanguage = targetCountriesData[myPicker.selectedRow(inComponent: target)]
        self.iOSOriginalLanguage = targetCountriesData[myPicker.selectedRow(inComponent: source)]
        
        PreferenceCriteria.sharedInstance.sourceSpeakingLanguage = sourceSpeakingLanguage
        PreferenceCriteria.sharedInstance.targetSpeakingLanguage = targetSpeakingLanguage
        PreferenceCriteria.sharedInstance.iOSSpeakingLanguage = iOSSpeakingLanguage
        PreferenceCriteria.sharedInstance.iOSOriginalLanguage = iOSOriginalLanguage
        
        
        //print("SOURCE LANG: \(sourceSpeakingLanguage), TARGET LANG: \(targetSpeakingLanguage), IOS: \(iOSSpeakingLanguage)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = colorWithHexString(hex: "011A46")
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        myPicker.delegate = self
        myPicker.dataSource = self
        let sourceIndex = sourceCountriesData.index(of: sourceSpeakingLanguage)
        let targetIndex = sourceCountriesData.index(of: targetSpeakingLanguage)
        
        myPicker.selectRow(sourceIndex!, inComponent:source, animated: false)
        myPicker.selectRow(targetIndex!, inComponent:target, animated: false)

        updateLabel()
    }

}

extension LanguageSelectionViewController {
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
