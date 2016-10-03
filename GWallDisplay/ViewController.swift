//
//  ViewController.swift
//  GWallDisplay
//
//  Created by Gary Damm on 8/4/16.
//  Copyright © 2016 Gimbal. All rights reserved.
//

import Cocoa
import WebKit
import AVKit
import AVFoundation

class ViewController: NSViewController {
    
    let DEFAULT_URL = "https://www.gimbal.com"
    let youTubeVideoHTML = "<!DOCTYPE html><html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'%@', height:'%@', videoId:'%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>"
    
    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var avPlayerView: AVPlayerView!
    
    var player = AVPlayer()
    let gwallManager = GWallManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gwallManager.delegate = self
        showWebView()
        let url = URL(string: DEFAULT_URL)
        let request = URLRequest(url: url!)
        self.webView.mainFrame.load(request)
    }
    
    func playYoutubeWithID(_ videoID: String) {
        let html = String(format: youTubeVideoHTML, "1920", "1080", videoID)
        self.webView.mainFrame.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
    }
    
    func showWebView() {
        self.avPlayerView.isHidden = true
        self.webView.isHidden = false
    }
    
}

extension ViewController : GWallManagerDelegate {
    
    func receivedURL(_ manager: GWallManager, urlString: String) {
        DispatchQueue.main.async(execute: {
            NSLog("receivedURL %@", urlString)
            
            if (urlString.contains("//")) {
                self.showWebView()
                let url = URL(string: urlString)
                let request = URLRequest(url: url!)
                self.webView.mainFrame.load(request)
            }else {
                self.showWebView()
                self.playYoutubeWithID(urlString)
            }
            
        })
    }
    
}

