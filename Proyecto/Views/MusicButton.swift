//
//  MusicButton.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 29/11/2021.
//

import UIKit

class MusicButton: UIButton {
    
    var icon : UIImage?
    var secondIcon : UIImage?
    var isPlaying : Bool = false
    

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
        //self.backgroundColor = .clear
        self.tintColor = .systemGreen
    }
    
    func performTwoStateSelection() {
        self.isPlaying = !isPlaying
        print(isPlaying)
        self.setImage(isPlaying ? icon : secondIcon, for: .normal)
        self.setImage(isPlaying ? icon : secondIcon, for: .highlighted)
    }
    
    func setImage(icon: UIImage?) {
        guard let icon = icon else { return }
        self.icon = icon
        self.setImage(icon, for: .normal)
        self.setImage(icon, for: .highlighted)
    }

}
