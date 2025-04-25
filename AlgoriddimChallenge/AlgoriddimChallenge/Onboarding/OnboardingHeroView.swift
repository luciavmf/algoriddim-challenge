//
//  OnboardingPageHeroView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

final class OnboardingHeroView: UIView {
    @MainActor
    private struct LabelConstants {
        static var fontSize: CGFloat = DeviceScreenSize.width <= 375 ? 22 : 34
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
        label.font = .systemFont(ofSize: LabelConstants.fontSize, weight: .bold)
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

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutChildren()
        activateCurrentConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutChildren()
        activateCurrentConstraints()
    }

    // MARK: Layout

    private func layoutChildren() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        heroView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(heroView)
        addSubview(stackView)
        addSubview(logoView)

        dynamicConstraints.portrait = [
            logoView.bottomAnchor.constraint(equalTo: heroView.topAnchor, constant: -Paddings.normal),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.heightAnchor.constraint(equalToConstant: 64),
            heroView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            heroView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),
            heroView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -Paddings.normal),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Paddings.normal)
        ]

        dynamicConstraints.landscape = [
            logoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Paddings.half),
            logoView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -Paddings.half * 2),
            logoView.heightAnchor.constraint(equalToConstant: 64),
            logoView.bottomAnchor.constraint(equalTo: heroView.topAnchor, constant: Paddings.normal),

            heroView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            heroView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -Paddings.half * 2),
            heroView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Paddings.normal),

            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Paddings.normal),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Paddings.normal),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),
            stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -Paddings.half * 2)
        ]
    }

    // MARK: Landscape - Portrait

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        activateCurrentConstraints()
    }

    private func activateCurrentConstraints() {
        NSLayoutConstraint.deactivate(dynamicConstraints.portrait + dynamicConstraints.landscape)

        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(dynamicConstraints.portrait)
        } else {
            NSLayoutConstraint.activate(dynamicConstraints.landscape)
        }
    }
}
