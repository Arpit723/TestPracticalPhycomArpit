//
//  Loader.swift
//  BlackBirdSmartWristBand
//
//  Created by Eww on 10/05/22.
//

import Foundation
import UIKit

import NVActivityIndicatorView

class Loader: NSObject {
    static var viewBG = UIView()
    static var loadingView: NVActivityIndicatorView?

    class func show() {
        viewBG.frame = appDelegate.window?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        viewBG.center = appDelegate.window?.center ?? CGPoint(x: 0, y: 0)
        viewBG.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 75.0, height: 75.0),type: .ballGridPulse, color: .gray,padding: 20.0)
        loadingView?.center = viewBG.center
        loadingView?.contentMode = .scaleAspectFill
        loadingView?.backgroundColor = .clear
        loadingView?.clipsToBounds = true
//        loadingView.animationSpeed = 1.5
//        loadingView.loopMode = .loop
    //        loadingView.layer.cornerRadius = 10

        loadingView?.contentMode = .scaleAspectFit
//        loadingView.transform = CGAffineTransform(scaleX: -1, y: 1)

        if !viewBG.subviews.contains(loadingView!) {
            viewBG.addSubview(loadingView!)
        }
        loadingView?.startAnimating()
        appDelegate.window?.addSubview(viewBG)
    }

    class func hide() {
        
        DispatchQueue.main.async(execute: {
            loadingView?.stopAnimating()
            viewBG.removeFromSuperview()
        })
    }
    
}

