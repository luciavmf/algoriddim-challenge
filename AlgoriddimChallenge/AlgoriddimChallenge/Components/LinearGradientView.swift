//
//  LinearGradientView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

/// A linear gradient view with the given colors.
final class LinearGradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    private var colors: [CGColor] = [UIColor.white.cgColor, UIColor.black.cgColor]

    private var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    private var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)

    // MARK: Initializers

    init(
        colors: [CGColor],
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1),
        frame: CGRect = .zero
    ) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint

        super.init(frame: frame)

        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure()
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }

    // MARK: Configure

    private func configure() {
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        layer.insertSublayer(gradientLayer, at: 0)
    }
}
