//
//  CollectionViewCell.swift
//  NeonAcademyFirestore
//
//  Created by Kerem Caan on 11.08.2023.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    let imageView: UIImageView = UIImageView()
    let usernameLabel: UILabel = UILabel()
    
    let commentButton: UIButton = UIButton()
    
    let vc = FeedVC()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(commentButton)
        commentButton.setImage(UIImage(systemName: "heart"), for: .normal)
        commentButton.addTarget(self, action: #selector(goToComments), for: .touchUpInside)
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalTo(50)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(contentView.snp.height).dividedBy(2)
            make.width.equalTo(contentView.snp.width)
        }
        usernameLabel.text = "deneme"
        usernameLabel.textColor = .blue
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.width.equalTo(contentView.snp.width)
        }
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        usernameLabel.text = nil
    }
    
    func configureUI(image:UIImage) {
        imageView.image = image
    }
    
    func setNames(name:String) {
        usernameLabel.text = name
    }
    
    @objc func goToComments() {
        vc.navigationController?.pushViewController(CommentsVC(), animated: true)
    }
}
