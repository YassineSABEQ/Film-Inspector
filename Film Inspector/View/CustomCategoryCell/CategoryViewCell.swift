//
//  CategoryViewCell.swift
//  Film Inspector
//
//  Created by Yassine Sabeq on 5/19/18.
//  Copyright © 2018 Yassine Sabeq. All rights reserved.
//

import UIKit

class CategoryViewCell: UITableViewCell {
    

    @IBOutlet weak var categoryLogo: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
