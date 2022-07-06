//
//  DetailViewController.swift
//  Techical
//
//  Created by Egor Evseenko on 05.07.22.
//

import UIKit

private enum Layout {
    static let stackSize: CGSize = .init(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.4)
    static let greatLabelBottomOffset: CGFloat = -20
    static let timeLabelTopOffset: CGFloat = 10
    
    static let cornerRadius: CGFloat = 12
    
    // Fonts
    static let greatLabelFontSize: CGFloat = 30
    static let timeLabelFontSize: CGFloat = 15
}

final class DetailViewController: UIViewController {
    var currentTime: Int?

    private var offerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.backgroundColor = .blue
        stack.layer.cornerRadius = Layout.cornerRadius
        return stack
    }()

    private var greatLabel: UILabel = {
        let label = UILabel()
        label.text = "Great!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Layout.greatLabelFontSize, weight: .black)
        return label
    }()

    private var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Layout.timeLabelFontSize, weight: .semibold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.6)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSubviews()
        setUpConstraints()
        setUpTime()
    }
    
    private func addSubviews() {
        view.addSubview(offerStackView)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        offerStackView.addSubview(greatLabel)
        offerStackView.addSubview(timeLabel)
    }

    private func setUpConstraints() {
        offerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        offerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        offerStackView.heightAnchor.constraint(equalToConstant: Layout.stackSize.height).isActive = true
        offerStackView.widthAnchor.constraint(equalToConstant: Layout.stackSize.width).isActive = true
        
        greatLabel.centerYAnchor.constraint(equalTo: offerStackView.centerYAnchor, constant: Layout.greatLabelBottomOffset).isActive = true
        timeLabel.topAnchor.constraint(equalTo: greatLabel.bottomAnchor, constant: Layout.timeLabelTopOffset).isActive = true
        [greatLabel, timeLabel].forEach {
            $0.centerXAnchor.constraint(equalTo: offerStackView.centerXAnchor).isActive = true
        }
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    private func setUpTime() {
        guard let currentTime = currentTime else { return }
        timeLabel.text = "Offer activated at \(currentTime.asString(style: .positional))"
    }
}



