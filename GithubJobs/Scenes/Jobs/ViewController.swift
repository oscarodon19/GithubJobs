//
//  ViewController.swift
//  GithubJobs
//
//  Created by Oscar Odon on 20/03/2021.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate, Loadable {

    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    var loadingView: LoadingView?

    var jobResults = [Job]()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadData()

        self.title = "Dev Jobs"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearchBar()
    }
}

extension ViewController {
    private func loadData() {
        displayLoading()
        getJobs(with: "jobs")
    }
    
    private func getJobs(with description: String) {
        Service.shared.getResults(description: description) { [weak self] result in
            switch result {
            case .success(let results):
                self?.jobResults = results
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.dismissLoading()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    self.dismissLoading()
                    let alertPopUp = UIAlertController(title: error.rawValue, message: nil, preferredStyle: .alert)
                    alertPopUp.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertPopUp, animated: true)
                }
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.placeholder = "Search by job title"
    }
}

//MARK: - TableView & TableViewDatasource Delegate

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { jobResults.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(jobResults[indexPath.row].title) - \(jobResults[indexPath.row].company) - \(jobResults[indexPath.row].location ?? "")"
        cell.textLabel?.numberOfLines = -1
        cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        cell.detailTextLabel?.text = jobResults[indexPath.row].createdAt
        cell.detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let jobUrlString = jobResults[indexPath.row].url,
              let jobUrl = NSURL(string: jobUrlString)
        else { return }
        
        let safariVC = SFSafariViewController(url: jobUrl as URL)
        present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
}

//MARK: - SearchBar Delegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let position = searchController.searchBar.text {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { [weak self] _ in
                guard let self = self else { return }
                self.getJobs(with: position)
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
        searchController.isActive = false
    }
}
