//
//  OnboardingButton.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

/// A button styled as the onbarding button. It has a press down state for the view.
final class OnboardingButton: UIButton {
    // MARK: Initializers

    init(title: String, target: Any?, action: Selector) {
        super.init(frame: .zero)

        configure(title: title, target: target, action: action)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure(title: "Continue", target: nil, action: nil)
    }

    // MARK: Configuration

    private func configure(title: String, target: Any?, action: Selector?) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        backgroundColor = .algoriddimBlue
        layer.cornerRadius = 12
        clipsToBounds = true

        if let action = action, let target = target {
            addTarget(target, action: action, for: .touchUpInside)
        }

        addTarget(self, action: #selector(pressDown), for: .touchDown)
        addTarget(self, action: #selector(releaseUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    // MARK: Press Effects

    @objc private func pressDown() {
        alpha = 0.7
    }

    @objc private func releaseUp() {
        UIView.animate(withDuration: AnimationDuration.fast) { [weak self] in
            self?.alpha = 1.0
        }
    }
}
