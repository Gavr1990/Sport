//
//  TableViewCell.swift
//  Sport
//
//  Created by Андрей Гаврилов on 11.04.2022.
//

import UIKit

final class TableViewCell: UITableViewCell {

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, indexPath: IndexPath, accessoryType: UITableViewCell.AccessoryType, name: String, place: String, time: String, type: String) { //,data: model
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = accessoryType
        
        let stackViewCell: UIStackView!
        
        let labelOfSport = UILabel()
        labelOfSport.font = UIFont.italicSystemFont(ofSize: 13)
        labelOfSport.numberOfLines = 0
        labelOfSport.textAlignment = .center
        labelOfSport.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)

        let labelOfPlace = UILabel()
        labelOfPlace.font = UIFont.italicSystemFont(ofSize: 13)
        labelOfPlace.textAlignment = .center
        labelOfPlace.numberOfLines = 0
        labelOfPlace.textColor = UIColor(red: 0, green: 0.721, blue: 0.029, alpha: 1)

        let labelOfTime = UILabel()
        labelOfTime.font = UIFont.italicSystemFont(ofSize: 13)
        labelOfTime.textAlignment = .center
        labelOfTime.numberOfLines = 0
        labelOfTime.textColor = UIColor(red: 0.721, green: 0.029, blue: 0, alpha: 1)

        labelOfSport.text = name
        labelOfPlace.text = place
        labelOfTime.text = time
                        
        stackViewCell = UIStackView(arrangedSubviews: [labelOfSport, labelOfPlace, labelOfTime])
        stackViewCell.distribution = .fillEqually

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.954, green: 1, blue: 0.956, alpha: 1)
        selectedBackgroundView = backgroundView
        
        if type == "Core Data" {
            backgroundColor = UIColor(red: 0, green: 0.721, blue: 0.029, alpha: 0.1)
        } else {
            backgroundColor = UIColor(red: 0.721, green: 0.029, blue: 0, alpha: 0.1)
        }
        
        stackViewCell.axis = .horizontal
        stackViewCell.alignment = .center
        stackViewCell.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackViewCell)

        stackViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackViewCell.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: stackViewCell.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: stackViewCell.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
