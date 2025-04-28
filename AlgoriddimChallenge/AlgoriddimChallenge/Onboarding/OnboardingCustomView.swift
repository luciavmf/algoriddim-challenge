//
//  OnboardingCustomView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 27.04.25.
//

import UIKit

final class OnboardingCustomView: UIView {
    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        confiure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        confiure()
    }

    func confiure() {
        let particles = ParticlesBackgroundView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        particles.translatesAutoresizingMaskIntoConstraints = false
        particles.clipsToBounds = true
        addSubview(particles)

        NSLayoutConstraint.activate([
            particles.leadingAnchor.constraint(equalTo: leadingAnchor),
            particles.trailingAnchor.constraint(equalTo: trailingAnchor),
            particles.topAnchor.constraint(equalTo: topAnchor),
            particles.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension OnboardingCustomView: TransitionAnimatable {
    func animateTransitionIn(backwards: Bool, completion: @escaping () -> Void) {
        slideAnimate(direction: .rightToMiddle, backwards: backwards, completion: completion)
    }

    func animateTransitionOut(backwards: Bool, completion: @escaping () -> Void) {
        completion()
    }
}
