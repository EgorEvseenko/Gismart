//
//  CustomButton.swift
//  Techical
//
//  Created by Egor Evseenko on 05.07.22.
//

import UIKit

final class GradientButton: UIButton {
    /// update inside layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            UIColor(red: 234/255, green: 72/255, blue: 187/255, alpha: 1).cgColor,
            UIColor(red: 65/255, green: 69/255, blue: 152/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.8)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }()
}
