//
//  ListVC.swift
//  DemoApp
//
//  Created by VAIBHAV JOSHI on 12/04/21.
//

import UIKit
import SwiftyJSON

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK:- Interface Builder Action Methods
    @IBOutlet private var roundView: [UIView]!
    @IBOutlet private weak var dataListTableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var allButton: UIButton!
    @IBOutlet private weak var favButton: UIButton!
    
    var allFoodArray: [MenuItems] = []
    var updatedArray: [MenuItems] = []
    var favouriteArray: [MenuItems] = []
    var selectedIndex = -1
    var isSearching = false
    var searchedArray: [MenuItems] = []
    var selectedButton = UIButton()
    
    //MARK:- Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.applyFinishingTouchUIElements()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedText = ""
        if let text = textField.text,
           let txtRange = Range(range, in: text) {
            updatedText = text.replacingCharacters(in: txtRange, with: string)
        }
        return true
    }
    
    //MARK:- UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (isSearching == false) ? updatedArray.count : searchedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.Data, for: indexPath) as! DataCell
        if(isSearching == false) {
            if let row = indexPath.row as? Int, let data = updatedArray[row] as? MenuItems {
                cell.set(foodData: data)
                
                cell.favButton.setImage(UIImage(named: (self.selectedIndex == data.idCategory) ? "heart" : "heart_black"), for: .normal)
                self.selectedIndex = -1
                cell.favButton.isHidden = false
                cell.favButton.tag = indexPath.row
                cell.favButton.addTarget(self, action: #selector(addToFavAction(_:)), for: .touchUpInside)
            }
        }
        else {
            if let row = indexPath.row as? Int, let data = updatedArray[row] as? MenuItems {
                cell.set(foodData: data)
                
                cell.favButton.setImage(UIImage(named: (self.selectedIndex == data.idCategory) ? "heart" : "heart_black"), for: .normal)
                self.selectedIndex = -1
                cell.favButton.isHidden = false
                cell.favButton.tag = indexPath.row
                cell.favButton.addTarget(self, action: #selector(addToFavAction(_:)), for: .touchUpInside)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    //MARK:- Interface Builder Action Methods
    @objc func addToFavAction(_ sender: UIButton) {
        if let row = sender.tag as? Int, let foodData = allFoodArray[row] as? MenuItems {
            guard let id = foodData.idCategory else { return }
            self.selectedIndex = id
            self.favouriteArray.append(foodData)
            showAlert("Added to favourite list.")
            self.dataListTableView.reloadData()
        }
    }
    
    @IBAction func showAllFoodItems(_ sender: UIButton) {
        updatedArray = []
        selectedButton = allButton
        updatedArray = allFoodArray
        self.dataListTableView.reloadData()
    }
    
    @IBAction func favouriteAction(_ sender: UIButton) {
        let array = unique(item: favouriteArray)
        selectedButton = favButton
        updatedArray = array
        self.dataListTableView.reloadData()
    }
    
    @IBAction func searchBarButtonAction(_ sender: UIBarButtonItem) {
        searchView.isHidden = !searchView.isHidden
        isSearching = searchView.isHidden
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        guard let searchedText = searchTextField.text else { return }
        if(searchedText.count == 0) {
            self.showAlert("Search Box is empty...")
            return
        }
        
        isSearching = (searchedText.count == 0) ? false : true
        searchedArray = updatedArray.filter({ (foodData) -> Bool in
            let foodName = foodData.strCategory
            return foodName?.range(of: searchedText, options: [.caseInsensitive], range: nil, locale: nil) != nil
        })
        self.dataListTableView.reloadData()
        
        
//        let url = URL_SEARCH_FOOD + searchedText
//        self.callAPI(url: url, type: 1)
    }
    
    @IBAction func clearAction(_ sender: UIButton) {
        searchView.isHidden = true
        searchTextField.text = ""
        isSearching = false
        if(selectedButton == allButton) {
            updatedArray = allFoodArray
        }
        else {
            updatedArray = favouriteArray
        }
        self.dataListTableView.reloadData()
    }
    
    //MARK:- UI Helpers
    private func applyFinishingTouchUIElements() {
        roundView.forEach { (vw) in
            vw.setCustomCorners(5.0, 0.0, .clear)
        }
        let nib = UINib(nibName: Identifier.Data, bundle: nil)
        dataListTableView.register(nib, forCellReuseIdentifier: Identifier.Data)
        selectedButton = allButton
        self.callAPI(url: URL_GET_MENU, type: 0)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- API Methods
    func callAPI(url: String, type: Int?) {
        shared.getRequest(url: url) { (response, statusCode, error) in
            if let err = error {
                self.showAlert(err.localizedDescription)
                return
            }
            
            if let resp = JSON(response) as? JSON, let categories = resp["categories"].arrayValue as? [JSON] {
                if(type == 0) {
                    self.allFoodArray = []
                }
                else {
                    self.updatedArray = []
                }
                categories.forEach { (data) in
                    let foodData = MenuItems(idCategory: data[idCategory].intValue, strCategory: data[strCategory].stringValue, strCategoryThumb: data[strCategoryThumb].stringValue, strCategoryDescription: data[strCategoryDescription].stringValue)
                    if(type == 0) {
                        self.allFoodArray.append(foodData)
                    }
                    else {
                        self.updatedArray.append(foodData)
                    }
                }
                self.updatedArray = self.allFoodArray
                self.dataListTableView.reloadData()
            }
        }
    }
}

struct Identifier {
    static let Data = "DataCell"
}

struct MenuItems: Equatable {
    var idCategory: Int?
    var strCategory: String?
    var strCategoryThumb: String?
    var strCategoryDescription: String?
    
    init() {}
    
    init(idCategory: Int?, strCategory: String?, strCategoryThumb: String?, strCategoryDescription: String?) {
        self.idCategory = idCategory
        self.strCategory = strCategory
        self.strCategoryThumb = strCategoryThumb
        self.strCategoryDescription = strCategoryDescription
    }
}


func unique(item: [MenuItems]) -> [MenuItems] {

    var uniqueItem = [MenuItems]()
    item.forEach { (menu) in
        if !(uniqueItem.contains(menu)) {
            uniqueItem.append(menu)
        }
    }
    return uniqueItem
}
