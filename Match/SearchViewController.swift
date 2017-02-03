//
//  SearchViewController.swift
//  Match
//
//  Created by Chandan Brown on 1/30/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit
import CoreImage
import NVActivityIndicatorView
import EZSwiftExtensions
import AVFoundation

class SearchViewController: UIViewController, NVActivityIndicatorViewable {
    
    var context = CIContext(options: nil)
    var loading: NVActivityIndicatorView?
    var searching: SearchingEnum?
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    
    lazy var loadingView: NVActivityIndicatorView = {
        let load = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        return load
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.frame = CGRect(x: 0, y: Constants.ScreenHeightWithoutStatusBar - Constants.navigationBarHeight, width: Constants.ScreenWidth, height: Constants.navigationBarHeight)
        return view
    }()
    
    lazy var videoView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        return view
    }()
    
    lazy var searchLabel: UILabel = {
        let label = UILabel()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startSearching))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Begin Search"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 42)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searching = SearchingEnum.notSearching
        self.loading = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.midX - 50, y: self.view.frame.midY - 60, width: 100, height: 100), type: NVActivityIndicatorType.lineScalePulseOut, color: .white, padding: NVActivityIndicatorView.DEFAULT_PADDING)
        view.backgroundColor = .clear
        view.addSubview(searchLabel)
        view.addSubview((self.loading)!)
        view.addSubview(bottomView)
        view.addSubview(videoView)
        view.sendSubview(toBack: videoView)
        setupSearchLabel()
    }
    
    func startSearching() {
        if searching == .notSearching {
            searching = .isSearching
            UIView.transition(with: searchLabel, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.session!.startRunning()
                self.setupCancelLabel()
                self.searchLabel.text = "Cancel"
                self.searchLabel.textColor = .red
                self.searchLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 28)
                self.loading?.startAnimating()
            }, completion:nil)
            
        } else if self.searchLabel.text == "Cancel" {
            self.setupSearchLabel()
            searching = .notSearching
            UIView.animate(withDuration: 1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.session?.stopRunning()
                self.videoView.backgroundColor = .darkGray
            }, completion: nil)
            self.loading?.stopAnimating()
            UIView.transition(with: searchLabel, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.searchLabel.text = "Begin Search"
                self.searchLabel.textColor = .white
                self.searchLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 42)
            }, completion:nil)
        }
    }
    
    func setupCancelLabel(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.0, animations: {
            self.searchLabelBottomAnchor?.constant = 210
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //add AVCaptureVideoPreviewLayer as sublayer of self.view.layer
        videoPreviewLayer?.frame = self.view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Setup camera
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        var backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        for element in devices! {
            let element = element as! AVCaptureDevice
            if element.position == AVCaptureDevicePosition.front {
                backCamera = element
                break
            }
        }
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            // ...
            stillImageOutput = AVCapturePhotoOutput()
            
            if session!.canAddOutput(stillImageOutput) {
                session!.addOutput(stillImageOutput)
                // ...
                // Configure the Live Preview
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                self.videoView.layer.addSublayer(videoPreviewLayer!)
                self.session!.startRunning()
                self.videoView.addBlurEffect()
            }
        }
    }
    
    var searchLabelBottomAnchor: NSLayoutConstraint?
    
    func setupSearchLabel() {
        // x, y, width, height
        self.searchLabelBottomAnchor?.isActive = false
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            self.searchLabelBottomAnchor = self.searchLabel.bottomAnchor.constraint(equalTo: (self.loading?.bottomAnchor)!, constant: -10)
            self.searchLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.searchLabel.widthAnchor.constraint(equalToConstant: 316).isActive = true
            self.searchLabel.heightAnchor.constraint(equalToConstant: 61.39).isActive = true
            self.searchLabelBottomAnchor?.isActive = true
            self.view.layoutIfNeeded()
        })
    }
    
}
