//
//  RecentMatchViewCell.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 29.04.2023.
//

import UIKit

class RecentMatchViewCell: UITableViewCell {
    
    let matchIDLabel = TappableLabel()
    let winnerLabel = UILabel()
    let killsLabel = UILabel()
    let deathsLabel = UILabel()
    let assistsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = UIColor(red: 0.11, green: 0.16, blue: 0.22, alpha: 1.0)
        
        addSubview(matchIDLabel)
        addSubview(winnerLabel)
        addSubview(killsLabel)
        addSubview(deathsLabel)
        addSubview(assistsLabel)
        
        matchIDLabel.translatesAutoresizingMaskIntoConstraints = false
        winnerLabel.translatesAutoresizingMaskIntoConstraints = false
        killsLabel.translatesAutoresizingMaskIntoConstraints = false
        deathsLabel.translatesAutoresizingMaskIntoConstraints = false
        assistsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            winnerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            winnerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            matchIDLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            matchIDLabel.leadingAnchor.constraint(equalTo: winnerLabel.trailingAnchor, constant: 10),
            matchIDLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            killsLabel.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 5),
            killsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            deathsLabel.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 5),
            deathsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            assistsLabel.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 5),
            assistsLabel.trailingAnchor.constraint(equalTo: matchIDLabel.trailingAnchor)
        ])
    }
    
    
    func configure(with match: RecentMatch) {
        matchIDLabel.text = "Match: \(match.matchID ?? 0)"
        matchIDLabel.textColor = .systemBlue
        matchIDLabel.onTap = {
            if let matchID = match.matchID {
                let urlString = URLS.dotaBuffMatchURL.rawValue + String(matchID)
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
        }
        winnerLabel.text = match.radiantWin ?? true ? "Radiant" : "Dire"
        winnerLabel.textColor = match.radiantWin ?? true ? .green : .red
        killsLabel.text = "Kills: \(match.kills ?? 0)"
        deathsLabel.text = "Deaths: \(match.deaths ?? 0)"
        assistsLabel.text = "Assists: \(match.assists ?? 0)"
    }
}

