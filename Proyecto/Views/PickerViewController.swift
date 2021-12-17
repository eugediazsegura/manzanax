//
//  PickerViewController.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 02/12/2021.
//

import Foundation
class PickerViewController: UIViewController{
  var selectedItem: String?
  //var items = [String]()
  @IBOutlet weak var picker: UIPickerView!
  @IBOutlet var tableView: UITableView!
  @IBAction func addButton(_ sender: Any) {
    playlist.append(selectedItem!)
      tableView.reloadData()
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    picker.dataSource = self
    picker.delegate = self
    tableView.dataSource = self
    tableView.delegate = self
  }
    
    func addSong(_ song: String){
        playlist.append(song)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    

}

extension PickerViewController: UIPickerViewDataSource{
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
    
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return misTracks.count
  }
    
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedItem = misTracks[row].title //Cuando me muevo, lo asigno a una variable
  }
}

extension PickerViewController: UIPickerViewDelegate{
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return misTracks[row].title  //Aca muestro el titulo
  }
}


extension PickerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
}


extension PickerViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return playlist.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "playcell", for: indexPath)
    cell.textLabel?.text = playlist[indexPath.row]
    return cell
  }
    
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
    
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      tableView.beginUpdates()
      playlist.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      tableView.endUpdates()
    }
  }
}




