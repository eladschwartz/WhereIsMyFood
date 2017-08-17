//
//  OrdersVC.swift
//  WhereIsMyFood-Driver
//
//  Created by elad schwartz on 25/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//



import UIKit
import SwiftyJSON
import LGSideMenuController

class OrdersVC: UIViewController  {
    
    @IBOutlet weak var searchRestaurant: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBAction func unwindToOrders(segue: UIStoryboardSegue) {}
    
    let activityIndicator = UIActivityIndicatorView()
    var orders = [Order]()
    var filteredOrders = [Order]()
    var indexPath = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func loadOrders() {
        APIManager.shared.getOrders { (json) in
            self.showActivityIndicator()
            if (json != JSON.null) {
                if (json == []) {
                     DispatchQueue.main.async() {
                        self.setOrdersEmpty()
                        
                    }
                    return
                }
                
                self.orders = []
                if let listOrders = json.array {
                    for item in listOrders {
                        let order = Order(json:item)
                        self.orders.append(order)
                    }
                     DispatchQueue.main.async() {
                        self.tableView.reloadData()
                        self.hideActivityIndicator()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadOrders()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromOrdersToDelivery" {
            let dest = segue.destination as! DeliveryVC
            let order = self.orders[self.indexPath]
            guard let orderId = order.id,
                  let orderAddress = order.customerAddress,
                  let customerName = order.customerName,
                  let floor = order.floorNumber,
                  let apartNum = order.apartmentNumber,
                  let customerPhone = order.phoneNumber else {return}
            
            
            dest.orderId = orderId
            dest.orderAddress = orderAddress
            dest.customerName = customerName
            dest.floorapart = "Floor: \(floor) Apartment:\(apartNum)"
            dest.customerPhone = customerPhone
            APIManager.shared.setActiveOrder(order_id: orderId) { (json) in}
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    @IBAction func refreshTable(_ sender: Any) {
        if let emptyOrdersView = self.view.viewWithTag(5001) {
            emptyOrdersView.removeFromSuperview()
        }
        self.loadOrders()
    }
    
    func setOrdersEmpty(){
            let emptyOrdersView = Bundle.main.loadNibNamed("EmptyOrders", owner: self, options: nil)?.first as? EmptyOrders
            if let emptyView = emptyOrdersView {
                emptyView.frame = self.view.frame
                emptyView.tag = 5001
                self.view.addSubview(emptyView)
            }
        
    }
}


extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchRestaurant.text != "" {
            return self.filteredOrders.count
        }
        
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let order: Order
        
        if searchRestaurant.text != "" {
            order = filteredOrders[indexPath.row]
        } else {
            order = orders[indexPath.row]
        }
        
        cell.customerNameLbl.text = order.customerName
        cell.customerAddressLbl.text = order.customerAddress
        cell.OrderIdLbl.text = "Order Number:  \(order.id!) "
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath.row
        performSegue(withIdentifier: "FromOrdersToDelivery", sender: self)
    }
}

extension OrdersVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredOrders = self.orders.filter({ (res: Order) -> Bool in
            return res.customerName?.lowercased().range(of:searchText.lowercased()) != nil
        })
        self.tableView.reloadData()
    }
}


