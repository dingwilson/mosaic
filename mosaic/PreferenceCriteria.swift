//
//  preferenceCriteria.swift
//  mosaic
//
//  Created by Kevin J Nguyen on 10/23/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

class PreferenceCriteria {
    
    var sourceSpeakingLanguage: String = "en"
    var targetSpeakingLanguage: String = "es"
    var iOSSpeakingLanguage: String = "es-MX"
    var iOSOriginalLanguage: String = "en-US"
    
    var pastTags : [String] = [String]()
    
    static let sharedInstance = PreferenceCriteria()
    //Other methods of the class....
}
