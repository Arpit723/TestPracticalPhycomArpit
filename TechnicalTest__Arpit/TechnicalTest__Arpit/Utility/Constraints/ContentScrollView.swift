//
//  ContentScrollView.swift
//  BlackBirdSmartWristBand
//
//  Created by Eww on 20/04/22.
//

import Foundation

import UIKit

class ContentScrollView: UIScrollView {

    /// Content View
    let contentView = customize(UIView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }

    /// Content view with full height enabled
    var contentViewFullHeight: Bool = false {
        didSet {
            heightContraint?.isActive = contentViewFullHeight
        }
    }

    var disableFullHeightWhileKeyboard: Bool = true

    /// Content View Height Contstraint
    private var heightContraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
        }
    }

    /// Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentView)
        contentView.attachTo(self)

        heightContraint = contentView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: 1)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1)
        ])

        // Add notification observer
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    /// Deinitialize
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// Initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        if disableFullHeightWhileKeyboard && contentViewFullHeight {
            heightContraint?.isActive = false
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        if disableFullHeightWhileKeyboard && contentViewFullHeight {
            heightContraint?.isActive = true
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }

    /// Setup in View Controller
    /// - Parameter controller: View Controller
    func setup(in controller: UIViewController) {
        let view = controller.view!
        view.addSubview(self)
        attachAnchors(view, leading: 0, trailing: 0)
        attachAnchors(top: (controller.topAnchor, 0), bottom: (controller.bottomAnchor, 0))
    }

}
