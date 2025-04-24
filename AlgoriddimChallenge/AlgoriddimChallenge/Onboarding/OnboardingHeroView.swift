//
//  OnboardingPageHeroView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

@MainActor
struct LogoSize {
    static var height: CGFloat = DeviceScreenSize.width <= 375 ? 44 : 64
}

final class OnboardingHeroView: UIView {
    @MainActor
    private struct LabelConstants {
        static var numberOfLines: Int = DeviceScreenSize.width <= 375 ? 1 : 0
    }

    private var logoView: UIImageView = {
        let uiimageView = UIImageView()
        uiimageView.contentMode = .scaleAspectFit
        uiimageView.image = UIImage(named: "Logo")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        return uiimageView
    }()

    private var heroView: UIImageView = {
        let uiimageView = UIImageView()
        uiimageView.contentMode = .scaleAspectFit
        uiimageView.image = UIImage(named: "Hero")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        uiimageView.translatesAutoresizingMaskIntoConstraints = false
        uiimageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiimageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return uiimageView
    }()

    private var titleLabel: UILabel  = {
        let label = UILabel()
        label.text = "Mix Your Favorite Music"
        label.font = .systemFont(ofSize: FontConstants.titleFontSize, weight: .bold)
        label.numberOfLines = LabelConstants.numberOfLines
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    private var appleDesignAwardView: UIImageView = {
        let uiimageView = UIImageView()
        uiimageView.contentMode = .scaleAspectFit
        uiimageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiimageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        uiimageView.image = UIImage(named: "AppleDesignAward")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        return uiimageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, appleDesignAwardView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Paddings.normal
        return stackView
    }()

    private var dynamicConstraints = Constraints()

    private var logoInitialConstraint = Constraints()
    private var logoFinalConstraint = Constraints()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutChildren()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutChildren()
        setupConstraints()
    }

    // MARK: Layout

    private func layoutChildren() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        heroView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(heroView)
        addSubview(stackView)
        addSubview(logoView)

        logoInitialConstraint.portrait = [
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.height * -0.1),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        logoFinalConstraint.portrait = [
            logoView.bottomAnchor.constraint(equalTo: heroView.topAnchor, constant: -Paddings.normal),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        logoInitialConstraint.landscape = [
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.height * -0.1),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        logoFinalConstraint.landscape = [
            logoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Paddings.normal),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -Paddings.normal)
        ]

        dynamicConstraints.portrait = makePortraitConstraints()
        dynamicConstraints.landscape = makeLandscapeConstraints()
    }

    private func makePortraitConstraints() -> [NSLayoutConstraint] {
        [
            logoView.heightAnchor.constraint(equalToConstant: LogoSize.height),

            heroView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            heroView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),
            heroView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -Paddings.normal),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Paddings.normal)
        ]
    }

    private func makeLandscapeConstraints() -> [NSLayoutConstraint] {
        [
            logoView.heightAnchor.constraint(equalToConstant: LogoSize.height),

            heroView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            heroView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -Paddings.half * 2),

            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Paddings.normal),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Paddings.normal),
            stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -Paddings.half * 2)
        ]
    }

    // MARK: Landscape - Portrait

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        activateCurrentConstraints()
    }

    private func deactivateConstraints() {
        NSLayoutConstraint.deactivate(dynamicConstraints.portrait + dynamicConstraints.landscape)
        NSLayoutConstraint.deactivate(logoInitialConstraint.portrait + logoInitialConstraint.landscape)
        NSLayoutConstraint.deactivate(logoFinalConstraint.portrait + logoFinalConstraint.landscape)
    }

    private func setupConstraints() {
        deactivateConstraints()

        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(dynamicConstraints.portrait)
            NSLayoutConstraint.activate(logoInitialConstraint.portrait)
        } else {
            NSLayoutConstraint.activate(dynamicConstraints.landscape)
            NSLayoutConstraint.activate(logoInitialConstraint.landscape)
        }
    }

    private func activateCurrentConstraints() {
        deactivateConstraints()

        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(dynamicConstraints.portrait)
            NSLayoutConstraint.activate(logoFinalConstraint.portrait)
        } else {
            NSLayoutConstraint.activate(dynamicConstraints.landscape)
            NSLayoutConstraint.activate(logoFinalConstraint.landscape)
        }
    }

    // MARK: Animations

    func animateTransitionIn(backwards: Bool = false, completion: @escaping () -> Void = { }) {
        animateLogo(backwards: backwards, completion: completion)

        UIView.animate(
            withDuration: AnimationDuration.slow,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: [.curveEaseInOut]
        ) { [weak self] in
            guard let self else { return }
            if backwards {
                self.stackView.alpha = 0
                self.stackView.transform = CGAffineTransform(scaleX: 0.3, y: 0.5)
                heroView.alpha = 0
                heroView.transform = CGAffineTransform(scaleX: 0.3, y: 0.5)
            } else {
                heroView.alpha = 1
                heroView.transform = .identity
                self.stackView.alpha = 1
                self.stackView.transform = .identity
            }
        }
    }

    private func animateLogo(backwards: Bool = false, completion: @escaping () -> Void = { }) {
        deactivateConstraints()

        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(dynamicConstraints.portrait)
            NSLayoutConstraint.activate(backwards ? logoInitialConstraint.portrait : logoFinalConstraint.portrait)
        } else {
            NSLayoutConstraint.activate(dynamicConstraints.landscape)
            NSLayoutConstraint.activate(backwards ? logoInitialConstraint.landscape : logoFinalConstraint.landscape)
        }

        UIView.animate(
            withDuration: AnimationDuration.normal,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut],
            animations: { [weak self] in
            // Animate the layout of the logo
            self?.layoutIfNeeded()
            }, completion: { _ in
                completion()
            }
        )

        if backwards {
            heroView.alpha = 1
            heroView.transform = .identity
            stackView.alpha = 1
            stackView.transform = .identity
        } else {
            heroView.alpha = 0
            heroView.transform = CGAffineTransform(scaleX: 0.3, y: 0.5)
            stackView.alpha = 0
            stackView.transform = CGAffineTransform(scaleX: 0.3, y: 0.5)
        }
    }
}
