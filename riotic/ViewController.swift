//
//  ViewController.swift
//  riotic
//
//  Created by Joakim Ahlén on 2016-10-12.
//  Copyright © 2016 Digistrada S.L. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, WKUIDelegate, PreferencesStorageDelegate {
    var settings: PreferencesStorage?
    
	@IBOutlet weak var webView: WKWebView!

	override func viewDidLoad() {
        super.viewDidLoad()
        
        settings = PreferencesStorage.sharedInstance

		self.webView.navigationDelegate = self
		self.webView.uiDelegate = self
		settings?.delegate = self

        self.loadClient()
    }

    func didConfigChange(sender: PreferencesStorage) {
        print("CONFIGURATION CHANGED! Reloading client...");
        loadClient()
    }
    
    private func loadClient() {
        let urlRawSetting = settings?.get(key: "riotClientUrl")

        guard let url = URL(string: urlRawSetting!) else {
			print("NIL URL! - \(String(describing: urlRawSetting))")
			return
		}

		guard url.isValidURL else {
			print("INVALID URL! - \(String(describing: urlRawSetting))")
			return
		}

		let request = NSURLRequest(url:url)
		print("Reloading web view with URL: \(String(describing: url))")
		webView.load(request as URLRequest)
    }
    
    private func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        switch navigationAction.navigationType {
        case .linkActivated:
            if navigationAction.targetFrame == nil {
                self.webView.load(navigationAction.request)
            }
        default:
            break
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, runOpenPanelWith openPanelParameters: WKOpenPanelParameters, initiatedByFrame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
        let openDialog = NSOpenPanel()
        if (openDialog.runModal() == NSApplication.ModalResponse.OK) {
            completionHandler([(openDialog.url)!])
        } else {
            print("File Dialog Cancelled!")
            completionHandler(nil);
        }
    }
    
    func webView(_ webView: WKWebView, runOpenPanelForFileButtonWith resultListener: WebOpenPanelResultListener!, allowMultipleFiles: Bool) {
        let openDialog = NSOpenPanel()
        if (openDialog.runModal() == NSApplication.ModalResponse.OK) {
            let fileName: String = (openDialog.url?.path)!
            resultListener.chooseFilename(fileName) // Use chooseFilenames for multiple files
        } else {
            print("File Dialog Cancelled!")
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let host = navigationAction.request.url?.host?.lowercased()
        let riotUrl = URL(string: (settings?.get(key: "riotClientUrl"))!)
        
        if (host != nil && host!.hasPrefix((riotUrl?.host)!)) {
            decisionHandler(.allow)
        } else {
            if (navigationAction.navigationType == WKNavigationType.linkActivated) {
                let url = navigationAction.request.url!
                NSWorkspace.shared.open(url)
            }
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
	
}
