//
//  DotaHeroesViewController.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 27.04.2023.
//

import Alamofire
import SwiftyJSON
import UIKit

class DotaHeroesViewController: UITableViewController {
    private var loadingIndicator: UIActivityIndicatorView!
    private var visibleCellIndices: Set<Int> = []
    private var dotaHeroes: [DotaHero?] = []
    
    private var selectedCellIndex = 0

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoadingIndicator()
        tableView.isHidden = true

        fetchHeroesData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = tableView.visibleCells.map { tableView.indexPath(for: $0)?.row ?? -1 }.filter { $0 >= 0 }
        visibleCellIndices = Set(visibleCells)
        tableView.reloadData()
    }

    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dotaHeroes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! DotaHeroesTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
        performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
}


extension DotaHeroesViewController {
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loadingIndicator.startAnimating()
    }
    
    private func fetchHeroesData() {
        NetworkManager.shared.getDataForHeroes { heroes in
            DispatchQueue.main.async {
                self.dotaHeroes = heroes
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
                self.tableView.isHidden = false
            }
        }
    }
    
    private func configureCell(_ cell: DotaHeroesTableViewCell, at indexPath: IndexPath) {
        let index = indexPath.row
        if let hero = dotaHeroes[index] {
            cell.heroName.text = hero.localized_name
            cell.backgroundColor = .gray
           
            if let icon = hero.icon {
                cell.loadImage(from: URLS.opedDotaURL.rawValue + icon)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let heroDetailsVC = segue.destination as? HeroDetailsViewController else { return }
        heroDetailsVC.dotaHeroes = dotaHeroes[selectedCellIndex]
    }
}
