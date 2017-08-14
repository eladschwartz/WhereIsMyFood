//
//  NotesVC.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 02/08/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit

class NotesVC: UIViewController {

    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var barTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.barTitle.title =  "Notes"
        self.notes.text = Tray.currentTray.restaurantNotes
    }

    @IBAction func doneBtnTapped(_ sender: Any) {
        Tray.currentTray.restaurantNotes = self.notes.text
        self.dismiss(animated: true, completion: nil)
    }
    
}
