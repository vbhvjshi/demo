//
//  DataCell.swift
//  DemoApp
//
//  Created by VAIBHAV JOSHI on 21/04/21.
//

import UIKit

class DataCell: UITableViewCell {
    
    @IBOutlet private weak var itemNameLabekl: UILabel!
    @IBOutlet private weak var itemDetailLabel: UILabel!
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet weak var favButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func set(foodData: MenuItems?) {
        if let data = foodData {
            if let name = data.strCategory {
                itemNameLabekl.text = name
            }
            if let imageURLString = data.strCategoryThumb {
                setImageUsingKingfisher(in: itemImageView, from: imageURLString)
            }
            if let detail = data.strCategoryDescription {
                itemDetailLabel.text = detail
            }
        }
    }
}
