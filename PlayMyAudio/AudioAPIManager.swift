//
//  AudioAPIManager.swift
//  PlayMyAudio
//
//  Created by Tracy Sablon on 24/11/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit

class AudioAPIManager: NSObject {
    
    static let audioAPI = AudioAPIManager();
    
    let localURL = "http://localhost:8000/";
    var playlistArray :[Audio] = [];
    var audioDict = [Int : String]();
    var test : Data!;
    
  
    //Request to API : GET all audio data
    func getAllPlaylist() {
        
        let allplaylistURL = localURL+"playlist";
        guard let requestURL = URL(string: allplaylistURL)else{
            print("Error: cannot create URL");
            return
        }
        
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config);
        let url = requestURL;
        //var dataDict = [Int : String]();
        
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
                for track in  self.playlistArray {
                
                    print("MainQueue :\(track)")
                }
            }
            
            
        });
        
        task.resume();
        

       /* getHTTPRequest(requestURL: url){
            audio in
            print("http request closure :\(audio)");
        };*/
    }
    
    //GET request to API
   /* func getHTTPRequest(requestURL: URL, callback: ((_ audio:Array<Audio>) -> Void)!){
        
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config);
        let url = requestURL;
        //var dataDict = [Int : String]();
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if let response = response {
                print(response)
                return
            }
            
            guard error == nil else{
                print(error!.localizedDescription);
                return
            }
            guard let responseData = data else{
                print("Error: did not receive data")
                return
            }
            
            callback(self.parseJson(data: responseData));
            
            
        });
        
        task.resume();
        
    }*/
    
    //Parse JSON result
    func parseJson(data:Data) -> Array<Audio>{
        var dataArray :[Audio] = [];
        do{
            if let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:Any]{
                
                if let audioList = json["list"] as? [[String:AnyObject]] {

                    for audioObj in audioList {
                        
                        if let id = audioObj["m_id"] as? Int{
                            
                            print("ID : \(id)");
                            
                            if let data = audioObj["m_data"] as? String{
                                
                                print("DATA OBJ");
                                //Create Audio Object from JSON result
                                //Push it to an Array of Audio Object
                                let audio = Audio(audioId: id, audioData: data);
                                
                                dataArray.append(audio)

                            }
                            
                        }
                    }
                }
                
            }
        }catch{
            
            print("error trying to convert data to JSON");
        }
        
        print("Count : \(dataArray.count)");
        //print("Dictionary : \(audioArray)\n");
        
        return dataArray;
    }
}
