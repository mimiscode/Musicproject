//
//  ViewController.swift
//  PlayMyAudio
//
//  Created by Tracy Sablon on 24/11/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    let localURL = "http://localhost:8000/"
    var player: AVAudioPlayer?
    var playlistArray :[Audio] = []
    var trackArray :[Audio] = []
    var tracks :[NSData] = []
    
    @IBOutlet weak var trackTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set this UIViewController as UITableView data source and delegate
        self.trackTableView.dataSource = self
        self.trackTableView.delegate = self
        
        self.getPlaylist()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID: String = "TrackCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TrackTableCell
        let track: Audio = self.playlistArray[indexPath.row]
        
        cell.trackTitle.text = track.audioTitle
        cell.trackPlayButton.tag = indexPath.row
        cell.trackPlayButton.addTarget(self, action: #selector(self.playAudioAction), for: UIControlEvents.touchUpInside)

        return cell
    }
    
    
    
    func playAudioAction(_ sender: UIButton!){
        if !playlistArray.isEmpty {
            let audioAtIndex = self.playlistArray[sender.tag]
            downloadTrack(trackTitle: audioAtIndex.audioTitle)
        }
    }
    
    //Play Audio with infinite loop
    func playAudio(audioData : NSData) {
        print("Play action")
        
        do{
            if let player = try?AVAudioPlayer(data: audioData as Data) {
                self.player = player
                player.play()
            }
        }
        catch{
            print("could not load the sound")
        }
    }
    
    //Download the track : Request to API : GET a sound data
    func downloadTrack(trackTitle:String) {
        
        let downloadTrackURL = "\(localURL)playlist/\(trackTitle)"
        guard let requestURL = URL(string: downloadTrackURL)else{
            print("Error: cannot create URL")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = requestURL;

        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            guard error == nil else{
                print(error!.localizedDescription);
                return
            }
            guard let responseData = data else{
                print("Error: did not receive data")
                return
            }
            
            self.trackArray = self.parseJson(data: responseData);
            
            let track : Audio = self.trackArray.first!
            let decodeTrack = track.decodeBase64String(base64String: track.audioData);
            
            DispatchQueue.main.async {
                self.playAudio(audioData: decodeTrack)
            }
        });
        task.resume();
    }
    
    //Request to API : GET all sounds data
    func getPlaylist() {
        
        let allplaylistURL = "\(localURL)playlist"
        guard let requestURL = URL(string: allplaylistURL)else{
            print("Error: cannot create URL")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = requestURL;
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            guard error == nil else{
                print(error!.localizedDescription);
                return
            }
            guard let responseData = data else{
                print("Error: did not receive data")
                return
            }
            
            self.playlistArray = self.parseJson(data: responseData);
            
            DispatchQueue.main.async {
                self.trackTableView.reloadData()
            }
        });
        task.resume();
    }
    
    //Parse JSON result
    func parseJson(data:Data) -> Array<Audio> {
        var dataArray :[Audio] = [];
        var audio : Audio;
        do{
            if let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:Any]{
                
                if let audioList = json["list"] as? [[String:AnyObject]] {
                    
                    for audioObj in audioList {
                        
                        if let id = audioObj["m_id"] as? Int{
                            
                            if let title = audioObj["m_name"] as? String{
                                
                                if let data = audioObj["m_data"] as? String{
                                    //Create Audio Object from JSON result
                                    //Push it to an Array of Audio Object
                                    audio = Audio(audioId: id, audioData: data, audioTitle: title);
                                    
                                } else {
                                    //Create Audio Object from JSON result
                                    //Push it to an Array of Audio Object
                                    audio = Audio(audioId: id, audioTitle: title)
                                }
                                dataArray.append(audio)
                            }
                        }
                    }
                }
            }
        } catch {
            print("error trying to convert data to JSON");
        }
        return dataArray;
    }
}
