//
//  ViewController.swift
//  Techical
//
//  Created by Egor Evseenko on 05.07.22.
//

import UIKit
import Combine

private enum Layout {
    static let numberOfLines: Int = 0
    static let vStackSpacing: CGFloat = 20
    static let mainStackHPadding: CGFloat = 10
    
    // Description
    static let cornerRadius: CGFloat = 12
    static let descriptionStackSpacing: CGFloat = 10
    static let activateButtonSize: CGSize = .init(width: 300, height: 63)
    static let descriptionStackButtomOffset: CGFloat = -30
    static let timerHeight: CGFloat = 41
    static let spacingAfterLastMinute: CGFloat = 12
    static let songInYourPocketHeight: CGFloat = 21
    static let spacingAfterPercertOff: CGFloat = 8
    static let spacingAfterForTrueFans: CGFloat = 12
    static let spacingAfterTime: CGFloat = 16
    static let spacingAfterSongsInYourPocket: CGFloat = 10
    static let spacingAfterActivateButton: CGFloat = 5
    static let timerSeparatorWidth: CGFloat = 10
    
    // Fonts
    static let lastMinuteTextSize: CGFloat = 22
    static let percentOffTextSize: CGFloat = 45
    static let forTrueFansTextSize: CGFloat = 15
    static let songsInYourPocketTextSize: CGFloat = 14
    static let timeTextSize: CGFloat = 15
    static let activateOfferTextSize: CGFloat = 15
    static let termsOfUseTextSize: CGFloat = 10
}

final class MainViewController: UIViewController {
    // MARK: - Properties
    private var viewModel = MainViewModel()
    private var cancellableSet: Set<AnyCancellable> = []
    
    private lazy var musicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "music")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var lastMinuteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LAST-MINUTE CHANCE!\nto claim your offer"
        label.sizeToFit()
        label.textAlignment = .center
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.lastMinuteTextSize, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let percentOffLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "90% OFF!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Layout.percentOffTextSize, weight: .black)
        label.numberOfLines = Layout.numberOfLines
        label.textColor = .white
        return label
    }()
    
    private let forTrueFansLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "For true music fans"
        label.textAlignment = .center
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.forTrueFansTextSize, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let songsInYourPocketLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hundreds of songs in your pocket"
        label.textAlignment = .left
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.songsInYourPocketTextSize, weight: .regular)
        label.textColor = .systemGray2
        return label
    }()
    
    private let songsInYourPocketLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hundreds of songs in your pocket"
        label.textAlignment = .left
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var activateOfferButton: GradientButton = {
        let button = GradientButton()
        button.isUserInteractionEnabled = true
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ACTIVATE OFFER", for: .normal)
        button.layer.cornerRadius = Layout.cornerRadius
        button.titleLabel?.font = UIFont.systemFont(ofSize: Layout.activateOfferTextSize, weight: .semibold)
        button.addTarget(self, action: #selector(showDetailView), for: .touchUpInside)
        return button
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = .zero
        return stack
    }()
    
    private let descriptionStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = Layout.descriptionStackSpacing
        return stack
    }()
    
    private let offerDescriptionStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.axis = .vertical
        return stack
    }()
    
    private let timerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.axis = .vertical
        return stack
    }()
    
    private var сurrentTimeStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = .zero
        return stack
    }()
    
    private var daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = ""
        label.backgroundColor = .gray.withAlphaComponent(0.4)
        label.layer.cornerRadius = Layout.cornerRadius
        label.textAlignment = .center
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.timeTextSize, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var hoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = ""
        label.backgroundColor = .gray.withAlphaComponent(0.4)
        label.layer.cornerRadius = Layout.cornerRadius
        label.textAlignment = .center
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.timeTextSize, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var minutesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = ""
        label.backgroundColor = .gray.withAlphaComponent(0.4)
        label.layer.cornerRadius = Layout.cornerRadius
        label.textAlignment = .center
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.timeTextSize, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var secondsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = ""
        label.backgroundColor = .gray.withAlphaComponent(0.4)
        label.layer.cornerRadius = Layout.cornerRadius
        label.textAlignment = .center
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.timeTextSize, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let termsOfUseStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = Layout.descriptionStackSpacing
        return stack
    }()
    
    private var privacyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Privacy"
        label.textColor = .systemGray3
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.termsOfUseTextSize, weight: .light)
        return label
    }()

    private var restoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Restore"
        label.textColor = .systemGray3
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.termsOfUseTextSize, weight: .light)
        return label
    }()

    private var termsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Terms"
        label.textColor = .systemGray3
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.termsOfUseTextSize, weight: .light)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        setUpConstraints()
        startTimer()
    }

    private func addSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(musicImageView)
        mainStackView.addArrangedSubview(descriptionStackView)
        
        descriptionStackView.addArrangedSubview(offerDescriptionStackView)
        descriptionStackView.addArrangedSubview(timerStackView)
        
        offerDescriptionStackView.addArrangedSubview(lastMinuteLabel)
        offerDescriptionStackView.addArrangedSubview(percentOffLabel)
        offerDescriptionStackView.addArrangedSubview(forTrueFansLabel)
        сurrentTimeStackView = createTimerStackView(elements: [daysLabel, hoursLabel, minutesLabel, secondsLabel])
        timerStackView.addArrangedSubview(сurrentTimeStackView)
        timerStackView.addArrangedSubview(songsInYourPocketLabel)
        timerStackView.addArrangedSubview(activateOfferButton)
        timerStackView.addArrangedSubview(termsOfUseStackView)
        termsOfUseStackView.addArrangedSubview(termsLabel)
        termsOfUseStackView.addArrangedSubview(restoreLabel)
        termsOfUseStackView.addArrangedSubview(privacyLabel)
    }
    
    private func setUpConstraints() {
        mainStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.mainStackHPadding).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.mainStackHPadding).isActive = true
        
        descriptionStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: .zero).isActive = true
        descriptionStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Layout.descriptionStackButtomOffset).isActive = true
        
        offerDescriptionStackView.setCustomSpacing(Layout.spacingAfterLastMinute, after: lastMinuteLabel)
        offerDescriptionStackView.setCustomSpacing(Layout.spacingAfterPercertOff, after: percentOffLabel)
        offerDescriptionStackView.setCustomSpacing(Layout.spacingAfterForTrueFans, after: forTrueFansLabel)
        сurrentTimeStackView.widthAnchor.constraint(equalToConstant: Layout.activateButtonSize.width).isActive = true
        сurrentTimeStackView.heightAnchor.constraint(equalToConstant: Layout.activateButtonSize.height).isActive = true
        activateOfferButton.widthAnchor.constraint(equalToConstant: Layout.activateButtonSize.width).isActive = true
        activateOfferButton.heightAnchor.constraint(equalToConstant: Layout.activateButtonSize.height).isActive = true
        
        сurrentTimeStackView.heightAnchor.constraint(equalToConstant: Layout.timerHeight).isActive = true
        songsInYourPocketLabel.heightAnchor.constraint(equalToConstant: Layout.songInYourPocketHeight).isActive = true
        [daysLabel, hoursLabel, minutesLabel, secondsLabel].forEach {
            $0.heightAnchor.constraint(equalTo: сurrentTimeStackView.heightAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: сurrentTimeStackView.widthAnchor, multiplier: 0.225).isActive = true
        }
        timerStackView.setCustomSpacing(Layout.spacingAfterTime, after: сurrentTimeStackView)
        timerStackView.setCustomSpacing(Layout.spacingAfterSongsInYourPocket, after: songsInYourPocketLabel)
        timerStackView.setCustomSpacing(Layout.spacingAfterActivateButton, after: activateOfferButton)
    }
    
    private func createTimerStackView(elements: [UILabel]) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        for i in 0...elements.count - 1 {
            if i != elements.count - 1 {
                stackView.addArrangedSubview(elements[i])
                stackView.addArrangedSubview(createSeparator())
            } else {
                stackView.addArrangedSubview(elements[i])
            }
        }
        return stackView
    }
    
    private func createSeparator() -> UILabel {
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: Layout.timerSeparatorWidth).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = ":"
        label.textAlignment = .center
        label.numberOfLines = Layout.numberOfLines
        label.font = UIFont.systemFont(ofSize: Layout.timeTextSize, weight: .semibold)
        label.textColor = .white
        return label
    }
    
    private func startTimer() {
        viewModel.startTimer()
        viewModel.$currentTime
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] currentTime in
                guard let self = self else { return }
                self.secondsLabel.text = currentTime.convertToDate(.seconds)
                self.minutesLabel.text = currentTime.convertToDate(.minutes)
                self.hoursLabel.text = currentTime.convertToDate(.hours)
                self.daysLabel.text = currentTime.convertToDate(.days)
            })
            .store(in: &cancellableSet)
    }
    
    @objc private func showDetailView() {
        viewModel.stopTimer()
        
        let detailVC = DetailViewController()
        detailVC.currentTime = viewModel.currentTime
        detailVC.modalPresentationStyle = .overCurrentContext
        present(detailVC, animated: true)
    }
}
