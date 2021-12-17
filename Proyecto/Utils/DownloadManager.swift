//
//  DownloadManager.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 16/12/2021.
//

import Foundation

class DownloadManager: NSObject, ObservableObject {
    static var shared = DownloadManager()
    
    private var urlSession: URLSession!
    @Published var tasks: [URLSessionTask] = []
    
    override private init() {
        super.init()
        
        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
        
        //Warning: Make sure that the URLSession is created only once (if an URLSession still
        //exist from a previous download, it doestn't create a new URLSession object but returns
        //the existing one with the old delegate object attached)
        
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        
        updateTasks()
    }
    
    func startDownload(url: URL) {
        
        let task = urlSession.downloadTask(with: url)
        task.resume()
        tasks.append(task)
        
    }
    
    private func updateTasks() {
        urlSession.getAllTasks{ tasks in
            DispatchQueue.main.async {
                self.tasks = tasks
            }
        }
    }
}

extension DownloadManager: URLSessionDelegate, URLSessionDownloadDelegate {
    
    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData _: Int64, totalBytesWritten _: Int64, totalBytesExpectedToWrite _: Int64){
        print("Progress \(downloadTask.progress.fractionCompleted) - for - \(downloadTask)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Download finished: \(location.absoluteString)")
    }
    
    func urlSession(_ : URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Download error: \(String(describing: error))")
        } else {
            print("Task finished: \(task)")
        }
        
    }
    
    
}
