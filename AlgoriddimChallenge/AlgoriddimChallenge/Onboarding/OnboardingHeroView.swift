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
        let stackView = UIStackView(arrangedSubviews: [heroView, titleLabel, appleDesignAwardView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Paddings.normal
        return stackView
    }()

    private var dynamicConstraints = Constraints()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutStackView()
        activateCurrentConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutStackView()
        activateCurrentConstraints()
    }

    // MARK: Layout

    private func layoutStackView() {
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        dynamicConstraints.portrait = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        dynamicConstraints.landscape = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -Paddings.half * 2),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
