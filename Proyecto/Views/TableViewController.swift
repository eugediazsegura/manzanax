//
//  TableViewController.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 05/11/2021.
//

import UIKit
import Jukebox
import CoreData

class TableViewController: UITableViewController {
    
    //var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(named: "Background")
        self.tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "trackCell")
        self.tableView.rowHeight = 80;
        
        //tracks = misTracks
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackList")
        //Leemos la info en COREDATA
        request.returnsObjectsAsFaults = false
        do {
            let result = try context!.fetch(request)
            misTracks = [Track]()
            for data in result as! [NSManagedObject] {
                let title = data.value(forKey: "title") as? String
                let artist = data.value(forKey: "artist") as? String
                let album = data.value(forKey: "album") as? String
                let song_id = data.value(forKey: "song_id") as? String
                let genre = data.value(forKey: "genre") as? String
                
                let track = Track(title: title ?? "", artist: artist ?? "", album: album ?? "", genre: genre ?? "", songId: song_id ?? "")
                misTracks.append(track)
                print(data.value(forKey: "title") as! String)
                
            }
            self.tableView.reloadData()
        } catch {
            
            print("Failed")
        }
        
        if true {
            //TODO: Quitamos esta linea solo si queremos buscar la info desde servicio
            RestServiceManager.shared.getToServer(responseType: [Track].self, method: .get, endpoint: "songs") { status, data in
                misTracks = [Track]()
                if let _data = data {
                    misTracks = _data
                    
                    if let _context = context {
                        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TrackList")
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                        
                        do {
                            try appDelegate.persistentStoreCoordinator?.execute(deleteRequest, with: _context)
                        } catch let error as NSError {
                            // TODO: handle the error
                            print(error)
                        }
                        
                        //Guardamos la info en COREDATA
                        for item in _data {
                            guard let trackEntity = NSEntityDescription.insertNewObject(forEntityName: "TrackList", into: _context) as? NSManagedObject else {
                                return
                            }
                            
                            trackEntity.setValue(item.artist, forKey: "artist")
                            trackEntity.setValue(item.title, forKey: "title")
                            trackEntity.setValue(item.songId, forKey: "song_id")
                            trackEntity.setValue(item.album, forKey: "album")
                            trackEntity.setValue(item.genre, forKey: "genre")
                            
                            do {
                                try _context.save()
                            } catch {
                                print("Could not save. \(error), \(error.localizedDescription)")
                            }
                        }
                        
                    }
                    print("info guardada")
                    self.tableView.reloadData()
                }
            }
        }
        
        
        
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
