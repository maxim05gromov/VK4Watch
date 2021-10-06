//
//  Cell.swift
//  VK4Watch
//
//  Created by Максим on 10.06.2021.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var NewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
