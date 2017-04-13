//
//  RepositoryCollectionViewCell.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 13/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import UIKit

class RepositoryCollectionViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""

    }
    
    func prepare(repository : RepositoryEntity) {
        self.titleLabel.text = repository.name
        self.descriptionLabel.text = repository.description

        
    }

}
