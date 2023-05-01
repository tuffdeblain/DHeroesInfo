//
//  DotaHeroesTableViewCell.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 27.04.2023.
//

import UIKit

class DotaHeroesTableViewCell: UITableViewCell {
    

    private static let imageCache = NSCache<NSString, UIImage>()
    
    private let heroImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let heroName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureContentView()
        configureHeroImage()
        configureHeroName()
        setupConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension DotaHeroesTableViewCell {
    private func configureContentView() {
        contentView.backgroundColor = UIColor(red: 0.11, green: 0.16, blue: 0.22, alpha: 1.0)
    }
    
    private func configureHeroImage() {
        contentView.addSubview(heroImage)
    }
    
    private func configureHeroName() {
        contentView.addSubview(heroName)
        heroName.textColor = .white
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heroImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            heroImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            heroImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            heroImage.widthAnchor.constraint(equalToConstant: 30),
            heroImage.heightAnchor.constraint(equalToConstant: 30),
            
            heroName.leadingAnchor.constraint(equalTo: heroImage.trailingAnchor, constant: 15),
            heroName.centerYAnchor.constraint(equalTo: heroImage.centerYAnchor),
            heroName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func loadImage(from imageURL: String) {
        if let cachedImage = Self.imageCache.object(forKey: imageURL as NSString) {
            self.heroImage.image = cachedImage
            return
        }
        
        ImageManager.shared.getUserImage(from: imageURL) { imageData in
            if let image = UIImage(data: imageData) {
                Self.imageCache.setObject(image, forKey: imageURL as NSString)
                DispatchQueue.main.async {
                    self.heroImage.image = image
                }
            }
        }
    }
}
