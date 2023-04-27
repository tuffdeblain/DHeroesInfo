import UIKit

class DotaHeroesTableViewCell: UITableViewCell {
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    let heroImage: UIImageView = {
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
        
        contentView.backgroundColor = UIColor(red: 0.11, green: 0.16, blue: 0.22, alpha: 1.0)
        contentView.addSubview(heroImage)
        contentView.addSubview(heroName)
        
        heroName.textColor = .white
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension DotaHeroesTableViewCell {
    func getImage(imageURL: String) {
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
