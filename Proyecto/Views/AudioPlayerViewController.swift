//
//  AudioPlayerViewController.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 12/11/2021.
//

import UIKit
import Jukebox


class AudioPlayerViewController: UIViewController, JukeboxDelegate {
    
    var descargando = false
    
    var songTrack: Track?
    
    var playButton : UIButton!
    
    var stopButton : UIButton!
    
    var sliderSong : UISlider!
    
    var volumeSlider : UISlider!
    
    var menuButton : UIButton!
    
    var isPlaying: Bool = false
    
    var mySound: Jukebox!
    
    var audioCellModel: AudioCellModel?
    
    let screenWidth: CGFloat =  UIScreen.screenWidth
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "Background")
        print(screenWidth)
        
        let label1 = UILabel()
        label1.text = audioCellModel?.songName
        label1.font = UIFont.boldSystemFont(ofSize: 25.0)
        label1.textColor = UIColor(named: "Titles")
        label1.autoresizingMask = .flexibleWidth
        label1.translatesAutoresizingMaskIntoConstraints=true
        label1.frame=CGRect(x: -40, y: 50, width: self.view.frame.width, height: 50)
        label1.textAlignment = .center
        self.view.addSubview(label1)
        
        menuButton = UIButton()
        menuButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        menuButton.autoresizingMask = .flexibleWidth
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(menuButton)
        menuButton.addAction(UIAction(title: "", handler: { (_) in
            print("Default Action")
        }), for: .touchUpInside)
        menuButton.menu = addMenuItems()
        self.view.addSubview(menuButton)
        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: label1.topAnchor, constant: 20),
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        let url = Bundle.main.url(forResource: "colors" , withExtension: "gif")
        let iv = UIImageView()
        let image = UIImage.animatedImage(withAnimatedGIFURL: url!)
        iv.image = image
        iv.autoresizingMask = .flexibleWidth
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(iv)
        NSLayoutConstraint.activate([
            iv.topAnchor.constraint(lessThanOrEqualTo: label1.bottomAnchor, constant: calcConstraintButton()),
            iv.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iv.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60)
        ])
        
        playButton = UIButton(type: .system)
        playButton.setTitle("Play", for:.normal)
        playButton.tintColor = UIColor(named: "label")
        //playButton.autoresizingMask = .scaleToFill
        playButton.translatesAutoresizingMaskIntoConstraints = false
        //playButton.frame=CGRect(x: 0, y: 190, width: 100, height: 40)
        playButton.addTarget(self, action: #selector(self.buttonTouch(_:)), for: .touchUpInside)
        self.view.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(greaterThanOrEqualTo: iv.bottomAnchor, constant: calcConstraintButton()),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            
        ])
        
        stopButton = UIButton(type: .system)
        stopButton.setTitle("Stop", for:.normal)
        stopButton.tintColor = UIColor(named: "label")
        stopButton.autoresizingMask = .flexibleWidth
        stopButton.translatesAutoresizingMaskIntoConstraints=false
        //stopButton.frame=CGRect(x: 200, y: 120, width: 100, height: 40)
        stopButton.addTarget(self, action: #selector(self.buttonTouch(_:)), for: .touchUpInside)
        self.view.addSubview(stopButton)
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: iv.bottomAnchor, constant: calcConstraintButton()),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
        ])
        
        sliderSong=UISlider ()
        sliderSong.autoresizingMask = .flexibleWidth
        sliderSong.translatesAutoresizingMaskIntoConstraints = false
        sliderSong.tintColor = UIColor.systemPurple
        sliderSong.addTarget(self, action: #selector(self.sliderTouchRep(_:)), for: .touchUpInside)
        self.view.addSubview(sliderSong)
        NSLayoutConstraint.activate([
            sliderSong.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 16),
            sliderSong.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sliderSong.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
        let label2 = UILabel()
        label2.text = "Volumen"
        label2.textColor = UIColor(named: "AccentColor")
        label2.font = UIFont.systemFont(ofSize: 15)
        label2.autoresizingMask = .flexibleWidth
        label2.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(label2)
        NSLayoutConstraint.activate([
            label2.topAnchor.constraint(equalTo: sliderSong.bottomAnchor, constant: 40),
            label2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        volumeSlider = UISlider ()
        volumeSlider.autoresizingMask = .flexibleWidth
        volumeSlider.translatesAutoresizingMaskIntoConstraints=false
        volumeSlider.addTarget(self, action: #selector(self.sliderTouchVol(_:)), for: .touchUpInside)
        self.view.addSubview(volumeSlider)
        NSLayoutConstraint.activate([
            volumeSlider.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 16),
            volumeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180),
            volumeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        
        guard let soundURL = Bundle.main.url(forResource: "bensound-ukulele", withExtension: "mp3") else {
            return
            
        }
        mySound = Jukebox(delegate: self, items: [
            JukeboxItem(URL: NSURL(string: "\(soundURL)")! as URL)
        ])
    }
    
    
    
    func addMenuItems() -> UIMenu {
        let actionsDictionary = [BtnMusic.download: descargar, BtnMusic.share: share, BtnMusic.add: add, BtnMusic.trash: eliminar]
        var items = [UIAction]()
        for opcion in BtnMusic.allCases {
            if opcion.title == BtnMusic.download.title && descargando {
                continue
            }
            items.append(.init(title: opcion.title, image: opcion.image, handler: {_ in
                actionsDictionary[opcion]?()
            }))
        }
        return .init(title: "", image: nil, children: items)
        
    }
    
    func eliminar() -> Void {
        guard let celda = audioCellModel else {return}
        
        if let cancionABorrar = playlist.firstIndex(where: {$0 == celda.songName}){
            playlist.remove(at: cancionABorrar)
            self.popUp("Borrado","Se ha borrado la cancion \(celda.songName)")
        }else{
            self.popUp("Error","La canción no se encuentra en tu playlist")
        }
        
        
        
    }
    
    func descargar() -> Void {
        guard let celda = audioCellModel else {return}
        if let cancionADescargar = misTracks.first(where:{ $0.title == celda.songName}){
            self.popUp("Descargando \n\((cancionADescargar.title)?.uppercased()) ","artista: \(cancionADescargar.artist ?? "")\n género: \(String(describing: cancionADescargar.genre!.rawValue))")
            DownloadManager.shared.startDownload(url: URL(string: "https://speed.hetzner.de/100MB.bin")!)
            descargando = true
            menuButton.menu = nil
            menuButton.menu = addMenuItems()
            
        }
        
    }
    
    func share() -> Void {
        mySound?.pause()
        guard let celda = audioCellModel else {return}
        if let shareSong = misTracks.first(where:{ $0.title == celda.songName}){
            let link = "https://api.whatsapp.com/send?text=canci%C3%B3n%3A%20%2A\(shareSong.title)%2A%0Aartista%3A%20_\(String(describing: shareSong.artist!))_%0Ag%C3%A9nero%3A%20\(String(describing: shareSong.genre!.rawValue))"
            let linkFormatted = link.replacingOccurrences(of: " ", with: "%20")
            print(linkFormatted)
            if let url = URL(string: linkFormatted) {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    func add() ->Void {
        guard let celda = audioCellModel else {return}
        if let cancionPlaylist = misTracks.first(where:{ $0.title == celda.songName}){
            playlist.append(cancionPlaylist.title!)
            self.popUp("Agregado","Se ha agregado a la playlist: \(celda.songName)")
        }
    }
    
    func calcConstraintButton() -> CGFloat {
        let restValue = 480.0
        var constraint = CGFloat()
        if(screenWidth > 800){
            constraint = screenWidth - restValue * 1.7
        }else {
            constraint = screenWidth - restValue
            
        }
        return constraint
    }
    
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
        if let currentTime = mySound?.currentItem?.currentTime,
           let duration = mySound?.currentItem?.meta.duration {
            let value = Float(currentTime / duration)
            sliderSong.value = value
        } else {
            return
        }
    }
    
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
    }
    
    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
    }
    
    func jukeboxDidUpdateMetadata(_ jukebox: Jukebox, forItem: JukeboxItem) {
    }
    
    @objc func buttonTouch(_ sender: UIButton ) {
        guard let btnPress = sender.titleLabel?.text else{
            return
        }
        if(btnPress == "Play" && !(isPlaying)){
            isPlaying = true
            mySound?.play()
            print("Se presionó el botón play")
        }
        if btnPress == "Stop" {
            isPlaying = false
            mySound?.pause()
            print("Se presionó el botón stop")
        }
    }
    
    @objc func sliderTouchRep(_ sender : UISlider){
        print("slider reproducción se ajustó en \(sender.value)")
    }
    
    @objc func sliderTouchVol(_ sender : UISlider){
        if let jk = mySound {
            jk.volume = volumeSlider.value
        }
        print("slider volumen se ajustó en \(sender.value)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            mySound?.play()
            isPlaying = true
            volumeSlider.value = 0.5
        }
        catch {
            print ("ocurrió un error \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mySound?.pause()
        isPlaying = false
        audioCellModel?.delegate.updateState()
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if(!isPlaying){
            mySound?.play()
            isPlaying = true
        }else{
            mySound?.pause()
            isPlaying = false
        }
        
        
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == .remoteControl {
            switch event!.subtype {
            case .remoteControlPlay :
                mySound?.play()
            case .remoteControlPause :
                mySound?.pause()
            case .remoteControlNextTrack :
                mySound?.playNext()
            case .remoteControlPreviousTrack:
                mySound?.playPrevious()
            case .remoteControlTogglePlayPause:
                if mySound?.state == .playing {
                    mySound?.pause()
                } else {
                    mySound?.play()
                }
            default:
                break
            }
        }
    }
}

