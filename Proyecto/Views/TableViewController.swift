//
//  TableViewController.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 05/11/2021.
//

import UIKit
import Jukebox

class TableViewController: UITableViewController {
    
    //var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(named: "Background")
        self.tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "trackCell")
        self.tableView.rowHeight = 80;
        
        //tracks = misTracks
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTracks(_:)),
                                               name: NSNotification.Name("updateTable"),
                                               object: nil)
        
        let _ = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { timer in
            NotificationCenter.default.post(name: NSNotification.Name("updateTable"), object: nil)
        }
    }
    
    @objc func updateTracks(_ notification: Notification) {
        //tracks.append(Track(title: "Porcelain", artist: "Moby", album: "Play", songId: "0", genre: nil, duration: 12.3))
        tableView.reloadData()
    }
        
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let callBack: ( [Track]?, Error? ) -> () = { canciones, error in
            if error != nil {
                print("No se pudo obtener la lista de canciones")
            }
            else {
                misTracks = canciones ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        RestServiceManager.shared.getToServer(responseType: [Track].self, method: .get, endpoint: "songs") { status, data in
            misTracks = [Track]()
            if let _data = data {
                misTracks = _data
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("updateTable"), object: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tracksFiltrados = DataManager.cancionesPorGenero(canciones: misTracks)
        //return tracks.count
        return tracksFiltrados.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)as! TrackTableViewCell
        let tracksFiltrados = DataManager.cancionesPorGenero(canciones: misTracks)
        //let elTrack = tracks[indexPath.row]
        let elTrack = tracksFiltrados[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.track = elTrack
        cell.parent = self
        cell.artist.text = elTrack.artist
        cell.title.text = elTrack.title
        return cell
    }
}

extension TableViewController: ButtonOnCellDelegate {
    
    func buttonTouchedOnCell(aCell: AudioCellModel) {
        let audioVC = AudioPlayerViewController()
        audioVC.audioCellModel = aCell
        self.present(audioVC, animated: true, completion: nil)
    }
    
    
}
