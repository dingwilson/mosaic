//
//  LoginViewController.swift
//  mosaic
//
//  Created by Wilson Ding on 10/22/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class LoginViewController: UIViewController {
    
    @IBOutlet weak var videoBackground: BackgroundVideo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
    }

    func setupBackground() {
        self.videoBackground.createBackgroundVideo(name: "Background", type: "mp4")
    }

}
