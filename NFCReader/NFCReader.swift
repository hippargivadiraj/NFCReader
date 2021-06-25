//
//  NFCReader.swift
//  NFCReader
//
//  Created by Vadiraj Hippargi on 6/24/21.
//

import Foundation
import CoreNFC



class NFCReader: NSObject, ObservableObject , NFCNDEFReaderSessionDelegate {
    
    // This is some Data that will be written
    var actualData = ""
    //creating a nil session
    var nfcSession: NFCNDEFReaderSession?
    
    func scan(data: String){
        //Pass data fron Function to actualData
        actualData = data
        //Create a Session
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        //Set up an alert Message
        nfcSession?.alertMessage = "Hold Your Iphone Near NFC Tag"
        //begin the session
        nfcSession?.begin()
    }
    
    
    
    func  readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        let str:String = actualData
        
        //if there are more tags found
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than one tag detected, Please try again"
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            return
        }
        
        let tag = tags.first!
        session.connect(to: tag) { error in
            if error != nil {}
            session.alertMessage = "Unable To Connect"
            session.invalidate()
            return
        }
        
        tag.queryNDEFStatus { ndefStatus, capacity , error in
            guard error == nil else {
                session.alertMessage = "Unable To Connect"
                session.invalidate()
                return
            }
            switch ndefStatus{
            case .notSupported:
            session.alertMessage = "Unable To Connect"
            session.invalidate()
            case .readOnly:
            session.alertMessage = "Unable To Connect"
            session.invalidate()
            case .readWrite:
            tag.writeNDEF(.init(records: [NFCNDEFPayload.wellKnownTypeURIPayload(string:"\(str)")! ] )) { error in
                if error != nil {
                    session.alertMessage = "session Failed"
                }else {
                    session.alertMessage = "You successfully wrote the tag"
                    
                }
                session.invalidate()
            }
            
            @unknown default:
                session.alertMessage = "Unknown Message"
            }
        }
    }
    
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
       
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
       
        
    }

}
