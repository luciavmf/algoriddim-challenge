//
//  OnboardingSelectLevelView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

protocol OnboardingSelectLevelViewDelegate: AnyObject {
    func onboardingSelectLevelView(_ view: OnboardingSelectLevelView, didSelectLevel level: SkillLevel)
}

final class OnboardingSelectLevelView: UIView {
    @MainActor
    private struct SelectLevelConstants {
        static let normal: CGFloat = DeviceScreenSize.width <= 375 ? 20 : 40
        static let iconSize: CGFloat =  DeviceScreenSize.width <= 375 ? 50 : 80
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

    private var headerView: UIView = {
        let view: UIView = .init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Spacers views used to center the whole view
    private let topSpacer = UIView()
    private let bottomSpacer = UIView()

    private lazy var firstOption: OnboardingCheckbox = {
        let checkbox = OnboardingCheckbox()
        checkbox.text = "I’m new to DJing"
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.addTarget(self, action: #selector(selectNew), for: .touchUpInside)
        return checkbox
    }()

    private lazy var secondOption: OnboardingCheckbox = {
        let checkbox = OnboardingCheckbox()
        checkbox.text = "I’ve used DJ apps before"
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.addTarget(self, action: #selector(selectAmmateur), for: .touchUpInside)
        return checkbox
    }()

    private lazy var thirdOption: OnboardingCheckbox = {
        let checkbox = OnboardingCheckbox()
        checkbox.text = "I’m a professional DJ"
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.addTarget(self, action: #selector(selectProffesional), for: .touchUpInside)
        return checkbox
    }()

    weak var delegate: OnboardingSelectLevelViewDelegate?

    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstOption, secondOption, thirdOption])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Paddings.checkbox
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [firstOption, secondOption, thirdOption].forEach { option in
            option.translatesAutoresizingMaskIntoConstraints = false
        }
        return stackView
    }()

    // MARK: Constraints

    private var dynamicConstraints = Constraints()

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
        layoutChildren()
        setupConstraints()
        activateConstraints()
    }

    private func layoutChildren() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        topSpacer.backgroundColor = .blue
        bottomSpacer.backgroundColor = .red
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false

        addSubview(topSpacer)
        addSubview(bottomSpacer)

        headerView.addSubview(iconView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)

        addSubview(headerView)

        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: headerView.topAnchor),
            iconView.heightAnchor.constraint(lessThanOrEqualToConstant: SelectLevelConstants.iconSize),
            iconView.widthAnchor.constraint(lessThanOrEqualToConstant: SelectLevelConstants.iconSize),
            iconView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: SelectLevelConstants.normal),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])

        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(optionsStackView)
    }

    private func setupConstraints() {
        dynamicConstraints.portrait = [
            topSpacer.topAnchor.constraint(equalTo: topAnchor, constant: Paddings.normal),
            topSpacer.widthAnchor.constraint(equalToConstant: 0),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),

            headerView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            headerView.bottomAnchor.constraint(equalTo: optionsStackView.topAnchor, constant: -SelectLevelConstants.normal),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.half),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.half),

            optionsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),
            optionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal),

            bottomSpacer.widthAnchor.constraint(equalToConstant: 0),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: bottomAnchor),

            topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor)
        ]

        dynamicConstraints.landscape = [
            topSpacer.topAnchor.constraint(equalTo: topAnchor),
            topSpacer.widthAnchor.constraint(equalToConstant: 0),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),

            headerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -Paddings.normal * 2),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.normal),

            bottomSpacer.widthAnchor.constraint(equalToConstant: 0),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: bottomAnchor),

            topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor),

            optionsStackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            optionsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -Paddings.normal * 2),
            optionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.normal)
        ]
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        activateConstraints()
    }

    private func activateConstraints() {
        NSLayoutConstraint.deactivate(dynamicConstraints.portrait + dynamicConstraints.landscape)

        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(dynamicConstraints.portrait)
        } else {
            NSLayoutConstraint.activate(dynamicConstraints.landscape)
        }
    }

    // MARK: Select options

    @objc private func selectNew() {
        secondOption.isSelected = false
        thirdOption.isSelected = false
        delegate?.onboardingSelectLevelView(self, didSelectLevel: .new)
    }

    @objc private func selectAmmateur() {
        firstOption.isSelected = false
        thirdOption.isSelected = false
        delegate?.onboardingSelectLevelView(self, didSelectLevel: .ammateur)
    }

    @objc private func selectProffesional() {
        firstOption.isSelected = false
        secondOption.isSelected = false
        delegate?.onboardingSelectLevelView(self, didSelectLevel: .professional)
    }
}

// MARK: Animations

extension OnboardingSelectLevelView: TransitionAnimatable {
    func animateTransitionIn(backwards: Bool = false, completion: @escaping () -> Void = { }) {
        slideAnimate(direction: .rightToMiddle, backwards: backwards, completion: completion)
    }

    func animateTransitionOut(backwards: Bool = false, completion: @escaping () -> Void = { }) {
        slideAnimate(direction: .middleToLeft, backwards: backwards, completion: completion)
    }
}
