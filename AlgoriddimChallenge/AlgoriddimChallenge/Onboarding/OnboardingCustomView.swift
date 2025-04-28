//
//  OnboardingCustomView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 27.04.25.
//

import UIKit

final class OnboardingCustomView: UIView {
    private var titleLabel: UILabel  = {
        let label = UILabel()
        label.text = "Start Mixing"
        label.font = .systemFont(ofSize: FontConstants.titleFontSize, weight: .bold)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Paddings.normal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [titleLabel, subtitleLabel].forEach { option in
            option.translatesAutoresizingMaskIntoConstraints = false
        }
        return stackView
    }()

    var selectedSkillLevel: SkillLevel? {
        didSet {
            titleLabel.text = "\(selectedSkillLevel?.titleText ?? "")"
            subtitleLabel.text = "\(selectedSkillLevel?.descriptionText ?? "")"
        }
    }

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        confiure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        confiure()
    }

    // MARK: Configure

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

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
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

// MARK: Custom skill level text

private extension SkillLevel {
    var titleText: String {
        switch self {
        case .new:
            return "Let's start with the basics 🎶"

        case .ammateur:
            return "Level up your skills 🔊"

        case .professional:
            return "Unleash your full potential 🎛️"
        }
    }

    var descriptionText: String {
        switch self {
        case .new:
            return "You're new to DJing — no problem! We'll guide you through every beat and every transition, step by step."

        case .ammateur:
            return "You’ve got some DJ app experience! Now we’ll polish your skills, teach smooth transitions, and get you club-ready."

        case .professional:
            return "Already a DJ? Perfect. Get ready to fine-tune your techniques, master advanced tricks, and unleash your full performance potential."
        }
    }
}
