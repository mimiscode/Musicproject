//
//  Audio.swift
//  PlayMyAudio
//
//  Created by Tracy Sablon on 25/11/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit

class Audio: NSObject {
    
    var audioId : Int!
    var audioTitle : String!
    var audioData : String!
    
    init(audioId:Int, audioData:String, audioTitle:String){
        self.audioId = audioId
        self.audioData = audioData
        self.audioTitle = audioTitle
    }
    
    init(audioId:Int, audioTitle:String){
        self.audioId = audioId
        self.audioTitle = audioTitle
    }
    

    
    //Decode base64 String from Audio object
    func decodeBase64String(base64String: String ) -> NSData{
        let decodeString = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0))
        
        return decodeString!
    }

}
