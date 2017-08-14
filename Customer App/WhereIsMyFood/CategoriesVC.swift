//
//  CategoriesVC.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 05/08/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoriesVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var activityIndicator = UIActivityIndicatorView()
    var categories = [Category]()
    var restaurant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        activityIndicator = Helpers.showActivityIndicator(view: self.view)
        //Set layout and spacing for collection view
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //set cell item size here
        layout.itemSize = CGSize(width: 180, height: 180)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        
        //Show menu with swipe Gesture
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        if self.revealViewController() != nil {
            self.menuBarButton = Helpers.initMenuBtn(controller: self, barBtn: self.menuBarButton)
        }
        
        APIManager.shared.getItemsCategories(completionHandler: { (json) in
            if (json != JSON.null) {
                if let listCategories = json.array {
                    for category in listCategories {
                        guard let categoryName =  category["category_name"].string,
                            let categoryId =  Int(category["id"].string!),
                            let imgUrl = category["image"].string else {
                                return
                        }
                        let category = Category(id: categoryId, name: categoryName, imageUrl: imgUrl)
                        self.categories.append(category)
                    }
                    DispatchQueue.main.async(){
                        self.collectionView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromCategoriesToItems" {
            let itemListVC = segue.destination as! ItemListVC
            itemListVC.restaurant = self.restaurant
            let index = sender as! Int
            if let categoryId =  self.categories[index].id {
                  itemListVC.categoryId = categoryId
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        guard let categoryName = categories[indexPath.row].name,
            let imageUrl = categories[indexPath.row].imageUrl,
            let categoryId =  categories[indexPath.row].id  else { return cell  }
        
        cell.categoryNameLbl.text = categoryName
        let url = URL(string: imageUrl)!
        APIManager.shared.loadImage(itemName: categoryName, itemId: categoryId, imgUrl: url, { (image) in
            DispatchQueue.main.async(){
                cell.categoryImage.image = image
            }
        })
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          self.performSegue(withIdentifier: "FromCategoriesToItems", sender: indexPath.row)
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CategoryCell", for: indexPath) as UICollectionReusableView
        return view
    }

}
