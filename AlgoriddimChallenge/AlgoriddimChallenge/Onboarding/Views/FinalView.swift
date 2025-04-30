//
//  FinalView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 27.04.25.
//

import UIKit

final class FinalView: UIView {
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

    private var iconView: UIImageView  = {
        let uiimageView = UIImageView()
        uiimageView.contentMode = .center
        uiimageView.image = UIImage(named: "Icon")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        return uiimageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Paddings.normal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [iconView, titleLabel, subtitleLabel].forEach { option in
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

    public lazy var particlesBackgroundView: ParticlesBackgroundView = {
        let particles = ParticlesBackgroundView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        particles.translatesAutoresizingMaskIntoConstraints = false
        return particles
    }()

    // MARK: Configure

    func confiure() {
        addSubview(particlesBackgroundView)

        NSLayoutConstraint.activate([
            particlesBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            particlesBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            particlesBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            particlesBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(stackView)
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: Paddings.normal * -2),
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal * 2),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal * 2),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -(44 + Paddings.normal))
            ])
        }
    }
}

extension FinalView: TransitionAnimatable {
    func animateTransitionIn(backwards: Bool, completion: @escaping () -> Void) {
        let group = DispatchGroup()

        group.enter()
        particlesBackgroundView.fadeIn(duration: AnimationDuration.fast, delay: backwards ? AnimationDuration.slow : 0, backwards: backwards, completion: {
            group.leave()
        })

        if backwards {
            stackView.alpha = 1
            stackView.transform = .identity
        } else {
            stackView.alpha = 0
            stackView.transform = CGAffineTransform(scaleX: 0.3, y: 0.5)
        }
        group.enter()
        UIView.animate(
            withDuration: AnimationDuration.slow,
            delay: backwards ? 0 : AnimationDuration.fast,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self else { return }
                if backwards {
                    stackView.alpha = 0
                    stackView.transform = CGAffineTransform(scaleX: 0.3, y: 0.5)
                } else {
                    stackView.alpha = 1
                    stackView.transform = .identity
                }
            },
            completion: { _ in
                group.leave()
            })

        group.notify(queue: .main) {
            completion()
        }
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
