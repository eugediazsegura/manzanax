//
//  WelcomeViewController.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 01/11/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBOutlet weak var imagenLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagenLogo.image = UIImage(named: "Loguito")
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
