//
//  OnboardingPageHeroView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

@MainActor
struct CustomImageSize {
    static var logoHeight: CGFloat = DeviceScreenSize.width <= 375 ? 44 : 64
    static var heroHeight: CGFloat = DeviceScreenSize.width <= 375 ? 100 : 140
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

    /// A view that holds the title and the apple design award view.
    private lazy var titleAndADAView = UIView()

    /// The constraints of the view in landscape and portrait mode.
    private var dynamicConstraints = Constraints()

    private var logoInitialConstraint = Constraints()
    private var logoFinalConstraint = Constraints()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutChildren()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutChildren()
    }

    // MARK: Layout

    private func layoutChildren() {
        layoutTitleAndADAView()

        logoView.translatesAutoresizingMaskIntoConstraints = false
        heroView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(heroView)
        addSubview(titleAndADAView)
        addSubview(logoView)

        logoInitialConstraint.portrait = [
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.height * -0.15),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        logoFinalConstraint.portrait = [
            logoView.bottomAnchor.constraint(equalTo: heroView.topAnchor, constant: -Paddings.normal),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        logoInitialConstraint.landscape = [
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.height * -0.15),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        logoFinalConstraint.landscape = [
            logoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Paddings.normal),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.bottomAnchor.constraint(equalTo: titleAndADAView.topAnchor, constant: -Paddings.normal)
        ]

        dynamicConstraints = makeDynamicConstraints()

        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(dynamicConstraints.portrait)
            NSLayoutConstraint.activate(logoInitialConstraint.portrait)
        } else {
            NSLayoutConstraint.activate(dynamicConstraints.landscape)
            NSLayoutConstraint.activate(logoInitialConstraint.landscape)
        }
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Mix Your Favorite Music"
        label.font = .systemFont(ofSize: FontConstants.titleFontSize, weight: .bold)
        label.numberOfLines = LabelConstants.numberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }

    private func makeAppleDesignAwardView() -> UIImageView {
        let uiimageView = UIImageView()
        uiimageView.contentMode = .scaleAspectFit
        uiimageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiimageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        uiimageView.image = UIImage(named: "AppleDesignAward")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        return uiimageView
    }

    private func layoutTitleAndADAView() {
        let titleLabel = makeTitleLabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let appleDesignAwardView = makeAppleDesignAwardView()
        appleDesignAwardView.translatesAutoresizingMaskIntoConstraints = false

        titleAndADAView.addSubview(titleLabel)
        titleAndADAView.addSubview(appleDesignAwardView)
        titleAndADAView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleAndADAView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleAndADAView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleAndADAView.trailingAnchor),
            appleDesignAwardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Paddings.normal),
            appleDesignAwardView.bottomAnchor.constraint(equalTo: titleAndADAView.bottomAnchor),
            appleDesignAwardView.leadingAnchor.constraint(equalTo: titleAndADAView.leadingAnchor),
            appleDesignAwardView.trailingAnchor.constraint(equalTo: titleAndADAView.trailingAnchor)
        ])
    }

    private func makeDynamicConstraints() -> Constraints {
        var constraint = Constraints()
        constraint.portrait = [
            logoView.heightAnchor.constraint(equalToConstant: CustomImageSize.logoHeight),

            heroView.heightAnchor.constraint(equalToConstant: CustomImageSize.heroHeight),
            heroView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            heroView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),
            heroView.bottomAnchor.constraint(equalTo: titleAndADAView.topAnchor, constant: -Paddings.normal),

            titleAndADAView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            titleAndADAView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),
            titleAndADAView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Paddings.normal)
        ]

        constraint.landscape = [
            logoView.heightAnchor.constraint(equalToConstant: CustomImageSize.logoHeight),

            heroView.centerYAnchor.constraint(equalTo: titleAndADAView.centerYAnchor),
            heroView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -Paddings.half * 2),
            heroView.leadingAnchor.constraint(equalTo: leadingAnchor),

            titleAndADAView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Paddings.half),
            titleAndADAView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),
            titleAndADAView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -Paddings.half * 2)
        ]

        return constraint
    }

    // MARK: Landscape - Portrait

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass ||
            previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            activateConstraints()
        }
    }

    private func deactivateConstraints() {
        NSLayoutConstraint.deactivate(dynamicConstraints.portrait + dynamicConstraints.landscape)
        NSLayoutConstraint.deactivate(logoInitialConstraint.portrait + logoInitialConstraint.landscape)
        NSLayoutConstraint.deactivate(logoFinalConstraint.portrait + logoFinalConstraint.landscape)
    }

    private func activateConstraints() {
        deactivateConstraints()

        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(dynamicConstraints.portrait)
            NSLayoutConstraint.activate(logoFinalConstraint.portrait)
        } else {
            NSLayoutConstraint.activate(dynamicConstraints.landscape)
            NSLayoutConstraint.activate(logoFinalConstraint.landscape)
        }
    }

}

// MARK: Animations

extension OnboardingHeroView: TransitionAnimatable {
    func animateTransitionIn(backwards: Bool = false, completion: @escaping () -> Void = { }) {
        animateLogo(backwards: backwards)

        let forwards = !backwards

        heroView.alpha = forwards ? 0 : 1
        heroView.transform = forwards ? CGAffineTransform(scaleX: 0.3, y: 0.5) : .identity
        titleAndADAView.alpha = forwards ? 0 : 1
        titleAndADAView.transform = forwards ? CGAffineTransform(scaleX: 0.3, y: 0.5) : .identity

        UIView.animate(
            withDuration: AnimationDuration.slow,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self else { return }
                if backwards {
                    self.titleAndADAView.alpha = 0
                    self.titleAndADAView.transform = CGAffineTransform(scaleX: 0.3, y: 0.5)
                    heroView.alpha = 0
                    heroView.transform = CGAffineTransform(scaleX: 0.3, y: 0.5)
                } else {
                    heroView.alpha = 1
                    heroView.transform = .identity
                    self.titleAndADAView.alpha = 1
                    self.titleAndADAView.transform = .identity
                }
            },
            completion: { _ in
                completion()
            })
    }

    func animateTransitionOut(backwards: Bool = false, completion: @escaping () -> Void = { }) {
        slideAnimate(direction: .middleToLeft, backwards: backwards, completion: completion)
    }

    private func animateLogo(backwards: Bool = false) {
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
            }
        )
    }
}
