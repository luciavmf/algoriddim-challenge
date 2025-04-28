//
//  ParticlesBackgroundView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 27.04.25.
//

import UIKit

final class ParticlesBackgroundView: UIView {
    private let emitterLayer = CAEmitterLayer()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmitter()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEmitter()
    }

    // MARK: Configure

    private func setupEmitter() {
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = CGSize(width: bounds.width, height: bounds.height)
        emitterLayer.backgroundColor = UIColor.clear.cgColor

        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 7.0
        cell.lifetimeRange = 2.0

        cell.velocity = 1
        cell.velocityRange = 10
        cell.scale = 1
        cell.scaleRange = 0.4
        cell.emissionRange = .pi * 2

        cell.contents = makeCircle(color: .white.withAlphaComponent(0.05))?.cgImage

        // Fade out over lifetime
        cell.alphaRange = 0.0
        cell.alphaSpeed = -0.1

        emitterLayer.emitterCells = [cell]
        layer.addSublayer(emitterLayer)
    }

    private func makeCircle(color: UIColor, size: CGSize = CGSize(width: 30, height: 30)) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        emitterLayer.emitterSize = CGSize(width: bounds.width, height: bounds.height)
        emitterLayer.backgroundColor = UIColor.red.cgColor
    }
}
