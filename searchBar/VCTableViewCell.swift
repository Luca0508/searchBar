//
//  VCTableViewCell.swift
//  searchBar
//
//  Created by 蕭鈺蒖 on 2022/6/12.
//

import UIKit
import SnapKit

class VCTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    lazy var cityLabel: UILabel = {
        return UILabel()
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setup UI

extension VCTableViewCell {
    private func setupLabel() {
        contentView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.centerX.equalTo(contentView.safeAreaLayoutGuide)
        }
        cityLabel.sizeToFit()
        cityLabel.textColor = .darkGray
    }
}

