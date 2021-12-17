//
//  TrackTableViewCell.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 07/11/2021.
//




import UIKit

class TrackTableViewCell: UITableViewCell {
    var track : Track?
    var parent : ButtonOnCellDelegate?
    
    
    var audioPlayer : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor(named: "imageColor")
        imgView.image = UIImage(named: "AudioTrack")
        return imgView
    }()
    
    var title : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor(named: "Titles")
        lab.text = "titulo de la canción"
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    var artist : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor(named: "label")
        lab.text = "artista"
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    var button : MusicButton = {
        let btn = MusicButton()
        btn.icon = UIImage(named: "PlayCircle")
        btn.secondIcon = UIImage(named: "pause-button")
        btn.performTwoStateSelection()
        btn.setImage(UIImage(named: "PlayCircle"), for: .normal)
        btn.backgroundColor = UIColor(named: "imageColor")
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(audioPlayer)
        
        NSLayoutConstraint.activate([
            audioPlayer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            audioPlayer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            audioPlayer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            audioPlayer.widthAnchor.constraint(equalTo: audioPlayer.heightAnchor)
        ])
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            title.heightAnchor.constraint(equalToConstant: 35),
            title.leadingAnchor.constraint(equalTo: audioPlayer.trailingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -5)
        ])
        addSubview(artist)
        NSLayoutConstraint.activate([
            artist.heightAnchor.constraint(equalToConstant: 35),
            artist.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            artist.leadingAnchor.constraint(equalTo: audioPlayer.trailingAnchor, constant: 15),
            artist.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -5)
        ])
        contentView.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(self.playAudio(_ :)), for: .allEvents)
    }
    
    @objc func playAudio(_ sender: UIButton ) {
        button.performTwoStateSelection()
        guard let button = parent else {
            return
        }
        button.buttonTouchedOnCell(aCell: .init(delegate: self, songName: title.text ??  ""))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackTableViewCell : CelDelegate {
    func updateState() {
        button.performTwoStateSelection()
    }
}
