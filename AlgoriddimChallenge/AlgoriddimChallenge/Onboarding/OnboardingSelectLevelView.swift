//
//  OnboardingSelectLevelView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

final class OnboardingSelectLevelView: UIView {
    @MainActor
    private struct SelectLevelConstants {
        static let normal: CGFloat = DeviceScreenSize.width <= 375 ? 20 : 40
        static let iconSize: CGFloat = 80
    }

    private var iconView: UIImageView  = {
        let uiimageView = UIImageView()
        uiimageView.contentMode = .center
        uiimageView.image = UIImage(named: "Icon")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        return uiimageView
    }()

    private var titleLabel: UILabel  = {
        let label = UILabel()
        label.text = "Welcome DJ"
        label.font = .systemFont(ofSize: FontConstants.titleFontSize, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "What’s your DJ skill level?"
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white.withAlphaComponent(0.6)
        return label
    }()

    private var headerView: UIView = UIView()

    private var firstOption: OnboardingCheckbox = {
        let checkbox = OnboardingCheckbox()
        checkbox.text = "I’m new to DJing"
        return checkbox
    }()

    private var secondOption: OnboardingCheckbox = {
        let checkbox = OnboardingCheckbox()
        checkbox.text = "I’ve used DJ apps before"
        return checkbox
    }()

    private var thirdOption: OnboardingCheckbox = {
        let checkbox = OnboardingCheckbox()
        checkbox.text = "I’m a professional DJ"
        return checkbox
    }()

    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstOption, secondOption, thirdOption])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Paddings.checkbox
        [firstOption, secondOption, thirdOption].forEach { option in
            option.translatesAutoresizingMaskIntoConstraints = false
            option.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }
        return stackView
    }()

    // MARK: Constraints

    private var headerConstraints = Constraints()
    private var stackConstraints = Constraints()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureView()
    }

    // MARK: Layout

    private func configureView() {
        layoutHeaderView()
        layoutStackView()

        activateConstraints()
    }

    private func layoutHeaderView() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(iconView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)

        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: SelectLevelConstants.iconSize),
            iconView.widthAnchor.constraint(equalToConstant: SelectLevelConstants.iconSize),
            iconView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            iconView.topAnchor.constraint(greaterThanOrEqualTo: headerView.topAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: SelectLevelConstants.normal),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])

        headerConstraints.portrait = [
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.bottomAnchor.constraint(equalTo: optionsStackView.topAnchor, constant: -SelectLevelConstants.normal),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        headerConstraints.landscape = [
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SelectLevelConstants.normal),
            headerView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -Paddings.half * 2),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ]
    }

    private func layoutStackView() {
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(optionsStackView)

        stackConstraints.portrait = [
            optionsStackView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
            optionsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        stackConstraints.landscape = [
            optionsStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Paddings.half * 2),
            optionsStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -Paddings.half * 2),
            optionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(optionsStackView)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        activateConstraints()
    }

    private func activateConstraints() {
        NSLayoutConstraint.deactivate(headerConstraints.portrait + headerConstraints.landscape)
        NSLayoutConstraint.deactivate(stackConstraints.portrait + stackConstraints.landscape)

        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(headerConstraints.portrait)
            NSLayoutConstraint.activate(stackConstraints.portrait)
        } else {
            NSLayoutConstraint.activate(headerConstraints.landscape)
            NSLayoutConstraint.activate(stackConstraints.landscape)
        }
    }

    func animateTransitionIn(backwards: Bool = false, completion: @escaping () -> Void = { }) {
        slideAnimate(direction: .rightToMiddle, backwards: backwards, completion: completion)
    }

    func animateTransitionOut(backwards: Bool = false, completion: @escaping () -> Void = { }) {
        slideAnimate(direction: .middleToLeft, backwards: backwards, completion: completion)
    }
}
