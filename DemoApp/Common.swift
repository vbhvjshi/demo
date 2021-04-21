//
//  Common.swift
//  DemoApp
//
//  Created by VAIBHAV JOSHI on 22/04/21.
//

import Foundation
import UIKit
import Kingfisher

//MARK:- API URL
let URL_GET_MENU = "http://www.themealdb.com/api/json/v1/1/categories.php"
let URL_SEARCH_FOOD = "http://www.themealdb.com/api/json/v1/1/search.php?f="


//MARK:- API Keys
let idCategory = "idCategory"
let strCategory = "strCategory"
let strCategoryThumb = "strCategoryThumb"
let strCategoryDescription = "strCategoryDescription"


//MARK:- Custom Color
let customColor = UIColor(displayP3Red: 18.0/255.0, green: 59.0/255.0, blue: 75.0/255.0, alpha: 1)



//MARK:- Set Image Using Kingfisher
func setImageUsingKingfisher(in imageView: UIImageView?, from urlString: String) {
    if let string = urlString as? String {
        if let stringURL = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            imageView?.kf.indicatorType = .activity
            imageView?.kf.setImage(with: URL(string: stringURL), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        }
    }
}
