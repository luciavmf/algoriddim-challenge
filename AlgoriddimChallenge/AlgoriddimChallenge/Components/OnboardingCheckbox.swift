//
//  OnboardingCheckbox.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

final class OnboardingCheckbox: UIControl {

    override var isSelected: Bool {
        get {
            super.isSelected
        }
        set {
            super.isSelected = newValue
            updateAppearance()
        }
    }

    var text: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }

    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Regular", size: 23)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    private lazy var checkbox: UIImageView = {
        let uiimageView = UIImageView()
        uiimageView.contentMode = .scaleAspectFit
        uiimageView.image = UIImage(named: isSelected ?  "CheckboxCircleFill" : "CheckboxCircle")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        return uiimageView
    }()

    private var background: UIView = {
        let view = UIView()
        view.backgroundColor = .checkboxBackround
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var border: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.algoriddimBlue.cgColor
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutView()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isSelected.toggle()
        sendActions(for: .touchUpInside)
    }

    private func updateAppearance() {
        checkbox.image = UIImage(named: isSelected ? "CheckboxCircleFill" : "CheckboxCircle")?.withRenderingMode(.alwaysOriginal)
        border.isHidden = !isSelected
    }

    private func layoutView() {
        label.translatesAutoresizingMaskIntoConstraints = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        border.translatesAutoresizingMaskIntoConstraints = false
        background.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        addSubview(checkbox)
        addSubview(border)
        addSubview(background)

        NSLayoutConstraint.activate([
            checkbox.topAnchor.constraint(equalTo: topAnchor, constant: Paddings.checkbox),
            checkbox.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Paddings.checkbox),
            checkbox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Paddings.half),
            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.widthAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            border.topAnchor.constraint(equalTo: topAnchor, constant: -2),
            border.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -2),
            border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2),
            border.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 2)
        ])

        let heightConstraint = background.heightAnchor.constraint(equalToConstant: 48)
        heightConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightConstraint
        ])

        border.isHidden = !isSelected

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: background.topAnchor),
            label.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: Paddings.half),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Paddings.half)
        ])
    }
}
