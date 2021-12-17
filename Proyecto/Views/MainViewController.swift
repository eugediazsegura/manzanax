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
        gesturesLoad()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func gesturesLoad(){
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let gesturePinch = UIPinchGestureRecognizer(target: self, action: #selector(didPinch))
        self.imagenLogo.addGestureRecognizer(gestureTap)
        self.imagenLogo.addGestureRecognizer(gesturePinch)
        self.imagenLogo.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let compilado = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let app = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        
        self.popUp("Info", "Version: \(version)\n Compilado: \(compilado)\n \(app)")
    }
    
    @objc func didPinch(_ sender: UIPinchGestureRecognizer){

        if let scale = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)) {
                   guard scale.a > 1.0 else { return }
                   guard scale.d > 1.0 else { return }
                    sender.view?.transform = scale
                   sender.scale = 1.0
        }
    }
}
