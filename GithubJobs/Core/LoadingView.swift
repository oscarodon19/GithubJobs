//
//  LoadingView.swift
//  GithubJobs
//
//  Created by Oscar Odon on 20/03/2021.
//

import UIKit

class LoadingView: UIView {
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func startAnimating() {
        spinner.startAnimating()
    }
    
    func stopAnimating() {
        spinner.stopAnimating()
    }
}

extension LoadingView {
    private func setupView() {
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupViewHierarchy() {
        addSubview(blurView)
        blurView.contentView.addSubview(spinner)
    }
    
    private func setupConstraints() {
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: superview.heightAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            spinner.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor)
        ])
    }
}
