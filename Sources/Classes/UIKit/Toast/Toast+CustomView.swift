//
//  Toast+CustomView.swift
//  Toast
//
//  Created by lei.ren on 2021/8/16.
//

import Foundation
import SnapKit
import UIKit

extension UIView {

    func toastCustomViewForMessage(_ message: String?, image: UIImage?, in superview: UIView, style: ToastStyle = ToastManager.shared.style) -> UIView? {
      
        guard message != nil || image != nil else {
            return nil
        }

        var messageLabel: UILabel?
        var imageView: UIImageView?

        let wrapperView = UIView()
        wrapperView.backgroundColor = style.backgroundColor
        wrapperView.layer.cornerRadius = style.cornerRadius

        if style.displayShadow {
            wrapperView.layer.shadowColor = UIColor.black.cgColor
            wrapperView.layer.shadowOpacity = style.shadowOpacity
            wrapperView.layer.shadowRadius = style.shadowRadius
            wrapperView.layer.shadowOffset = style.shadowOffset
        }

        if let image = image {
            imageView = UIImageView(image: image)
            imageView?.contentMode = .scaleAspectFit
            imageView?.frame = CGRect(x: style.horizontalPadding,
                                      y: style.verticalPadding,
                                      width: image.size.width,
                                      height: image.size.height)
        }

        if let message = message, message.isEmpty == false {

            messageLabel = UILabel()
            messageLabel?.text = message
            messageLabel?.numberOfLines = style.messageNumberOfLines
            messageLabel?.font = style.messageFont
            messageLabel?.textAlignment = style.messageAlignment
            messageLabel?.lineBreakMode = .byTruncatingTail;
            messageLabel?.textColor = style.messageColor
            messageLabel?.backgroundColor = UIColor.clear
        }

        if let imageView = imageView {
            wrapperView.addSubview(imageView)
        }

        if let messageLabel = messageLabel {
            wrapperView.addSubview(messageLabel)
        }

        imageView?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(style.verticalPadding)
        })

        messageLabel?.snp.makeConstraints({ make in
            if let imageView = imageView {
                make.top.equalTo(imageView.snp.bottom).offset(12)
            } else {
                make.top.equalToSuperview().offset(style.verticalPadding)
            }
            make.left.right.equalToSuperview().inset(style.horizontalPadding)
            make.bottom.equalToSuperview().inset(style.verticalPadding)
        })

        superview.addSubview(wrapperView)

        wrapperView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            if let _ = imageView {
                make.width.greaterThanOrEqualTo(100)
                make.width.lessThanOrEqualTo(134)
            } else {
                let maxW = superview.bounds.size.width * style.maxWidthPercentage
                make.width.greaterThanOrEqualTo(120)
                make.width.lessThanOrEqualTo(maxW)
            }
        }
        return wrapperView
    }
}

