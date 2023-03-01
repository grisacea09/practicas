//
//  CustomCellCollectionViewCell.swift
//  practica2
//
//  Created by Grisel Angelica Perez Quezada on 28/02/23.
//

import UIKit

class CustomCellCollectionViewCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "BERNIERShade-Regular", size: 30)
        label.textColor = UIColor.red
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    

        override func awakeFromNib()
        {
            super.awakeFromNib()
            nameLabel.textColor = UIColor.cyan
            nameLabel.font = UIFont(name: "BERNIERShade-Regular", size: 30)
        }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        
        backgroundColor = UIColor.orange
        nameLabel.textColor = UIColor.blue
        nameLabel.font = UIFont(name: "BERNIERShade-Regular", size: 30)
                addSubview(nameLabel)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
