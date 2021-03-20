//
//  Loadable.swift
//  GithubJobs
//
//  Created by Oscar Odon on 20/03/2021.
//

import UIKit

protocol Loadable: UIViewController {
    var loadingView: LoadingView? { get set }
    func displayLoading()
    func dismissLoading()
}

extension Loadable {
    func displayLoading() {
        loadingView = LoadingView()
        guard let loadingView = loadingView else { return }
        DispatchQueue.main.async {
            loadingView.startAnimating()
            self.view.addSubview(loadingView)
        }
    }
    
    func dismissLoading() {
        guard let loadingView = loadingView else { return }
        DispatchQueue.main.async {
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
}
