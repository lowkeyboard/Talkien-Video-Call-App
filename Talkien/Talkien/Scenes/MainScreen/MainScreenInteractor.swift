//
//
//

import AVFoundation
import WebRTC
import FirebaseDatabase
import SwiftyJSON

final class MainScreenInteractor: NSObject,  MainScreenInteractorProtocol {
    
    func selectMovie(at index: Int) {
        print("")
        
    }
    
    
    
    func giveMicPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("Permission granted")
//                getusermedia
        case .denied:
            print("Permission denied")
        case .undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                // Handle granted
            })
        @unknown default:
            print("Unknown case")
        }
    }
    
    

    weak var delegate: MainScreenInteractorDelegate?
 
    var peerConnectionFactory: RTCPeerConnectionFactory! = nil
    var peerConnection: RTCPeerConnection! = nil
    var audioSource: RTCAudioSource?
    
    var observerSignalRef: DatabaseReference? = nil
    var offerSignalRef: DatabaseReference? = nil
    
    var sender: Int = 1
    var receiver: Int = 2

    
    
    deinit {
        if peerConnection != nil {
            hangUp()
        }
        audioSource = nil
        peerConnectionFactory = nil
    }
    

    func loadInteractor() {
        // RTCPeerConnectionFactory
        self.peerConnectionFactory = RTCPeerConnectionFactory()
        
        self.startRTCPeerConn()
        self.setupFirebase()
        
        observerSignalRef = Database.database().reference()
    }
    
    
    func setupFirebase() {
        
        self.observerSignalRef = Database.database().reference().child("Call/\(receiver)")
        self.offerSignalRef = Database.database().reference().child("Call/\(sender)")
        
        self.offerSignalRef?.onDisconnectRemoveValue()
        self.observerSignal()
    }
    
    
    //retrieving
    func observerSignal() {
        
        self.observerSignalRef?.observe(.value, with: { [weak self] (snapshot) in
            
            guard snapshot.exists() else { return }
            print("message: \(snapshot.value ?? "NO Value")")
            
            let jsonMessage = JSON(snapshot.value!)
            let type = jsonMessage["type"].stringValue
            switch (type) {
            case "offer":
                print("Received offer ...")
                let offer = RTCSessionDescription(
                    type: RTCSessionDescription.type(for: type),
                    sdp: jsonMessage["sdp"].stringValue)
                self?.setOffer(offer)
                
            case "answer":
                print("Received answer ...")
                let answer = RTCSessionDescription(
                    type: RTCSessionDescription.type(for: type),
                    sdp: jsonMessage["sdp"].stringValue)
                self?.setAnswer(answer)
                
            case "candidate":
                print("Received ICE candidate ...")
                let candidate = RTCIceCandidate(
                    sdp: jsonMessage["ice"]["candidate"].stringValue,
                    sdpMLineIndex: jsonMessage["ice"]["sdpMLineIndex"].int32Value,
                    sdpMid: jsonMessage["ice"]["sdpMid"].stringValue)
                self?.addIceCandidate(candidate)
                
            case "close":
                print("peer is closed ...")
                self?.hangUp()
            default:
                return
            }
        })
        
    }
    
    

    
    func startRTCPeerConn() {
        let audioSourceConstraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        audioSource = peerConnectionFactory.audioSource(with: audioSourceConstraints)
        
    }
    
    
    func prepareNewConnection() -> RTCPeerConnection {
        let configuration = RTCConfiguration()
        configuration.iceServers = [RTCIceServer.init(urlStrings: ["stun:stun.l.google.com:19302",
                                                                   "stun:stun2.l.google.com:19302",
                                                                   "stun:stun3.l.google.com:19302",
                                                                   "stun:stun4.l.google.com:19302"])]
        
        let peerConnectionConstraints = RTCMediaConstraints(
            mandatoryConstraints: nil, optionalConstraints: nil)

        let peerConnection = peerConnectionFactory.peerConnection(with: configuration, constraints: peerConnectionConstraints, delegate: self)
        
        let localAudioTrack = peerConnectionFactory.audioTrack(with: audioSource!, trackId: "ARDAMSa0")
        let audioSender = peerConnection.sender(withKind: kRTCMediaStreamTrackKindAudio, streamId: "ARDAMS")
        audioSender.track = localAudioTrack
        
   
        
        return peerConnection
    }
    
  
//    @IBAction func connectButtonAction(_ sender: Any) {
//        // Connectボタンを押した時
//        if peerConnection == nil {
//            print("make Offer")
//            makeOffer()
//        } else {
//            print("peer already exist.")
//        }
//    }
    
    
    func makeOffer() {
        
        peerConnection = prepareNewConnection() 
        
        let constraints = RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio": "true", "OfferToReceiveVideo": "false"],
                                              optionalConstraints: nil)
        let offerCompletion = { (offer: RTCSessionDescription?, error: Error?) in
            
            if error != nil { return }
            print("createOffer() succsess")
            let setLocalDescCompletion = {(error: Error?) in
                
                if error != nil { return }
                print("setLocalDescription() succsess")
                
                self.sendSDP(offer!)
            }
            
            self.peerConnection.setLocalDescription(offer!, completionHandler: setLocalDescCompletion)
        }
        
        
        self.peerConnection.offer(for: constraints, completionHandler: offerCompletion)
        
    }
    
    
    func makeAnswer() {
        print("sending Answer. Creating remote session description...")
        if peerConnection == nil {
            print("peerConnection NOT exist!")
            return
        }
        
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        let answerCompletion = { (answer: RTCSessionDescription?, error: Error?) in
            if error != nil { return }
            print("createAnswer() succsess")
            let setLocalDescCompletion = {(error: Error?) in
                if error != nil { return }
                print("setLocalDescription() succsess")
                
                self.sendSDP(answer!)
            }
            self.peerConnection.setLocalDescription(answer!, completionHandler: setLocalDescCompletion)
        }
        
        self.peerConnection.answer(for: constraints, completionHandler: answerCompletion) // Answerを生成
    }
    
    
    func sendSDP(_ desc: RTCSessionDescription) {
        print("---sending sdp ---")
        
        let jsonSdp: JSON = [
            "sdp": desc.sdp,
            "type": RTCSessionDescription.string(for: desc.type) // offer か answer か
        ]
        let message = jsonSdp.dictionaryObject

        self.offerSignalRef?.setValue(message) { (error, ref) in
            if error != nil {
                print("Dang sendIceCandidate -->> ", error.debugDescription)
            }
        }
    }
    
    
    func setOffer(_ offer: RTCSessionDescription) {
        if peerConnection != nil {
            print("peerConnection alreay exist!")
        }
        
//        APP_DELGATE.callManager?.receiveCall()
        
        peerConnection = prepareNewConnection() // PeerConnectionを生成する
        self.peerConnection.setRemoteDescription(offer, completionHandler: {(error: Error?) in
            if error == nil {
                print("setRemoteDescription(offer) succsess")
                self.makeAnswer() // setRemoteDescriptionが成功したらAnswerを作る
            } else {
                print("setRemoteDescription(offer) ERROR: " + error.debugDescription)
            }
        })
    }
    
    
    func setAnswer(_ answer: RTCSessionDescription) {
        if peerConnection == nil {
            print("peerConnection NOT exist!")
            return
        }
        
        self.peerConnection.setRemoteDescription(answer, completionHandler: {
            (error: Error?) in
            if error == nil {
                print("setRemoteDescription(answer) succsess")
            } else {
                print("setRemoteDescription(answer) ERROR: " + error.debugDescription)
            }
        })
    }
    
    
    func addIceCandidate(_ candidate: RTCIceCandidate) {
        if peerConnection != nil {
            peerConnection.add(candidate)
        } else {
            print("PeerConnection not exist!")
        }
    }
    
    
//    @IBAction func hangupButtonAction(_ sender: Any) {
//
//        hangUp() // HangUpボタンを押した時
//    }
//
    
    func hangUp() {
        if peerConnection != nil {
            if peerConnection.iceConnectionState != RTCIceConnectionState.closed {
                peerConnection.close()
                let jsonClose: JSON = ["type": "close"]
                
                let message = jsonClose.dictionaryObject
                print("sending close message")
                let ref = Database.database().reference().child("Call/\(sender)")
                ref.setValue(message) { (error, ref) in
                    print("Dang send SDP Error -->> ", error.debugDescription)
                }
                
            }
            
            peerConnection = nil
            print("peerConnection is closed.")
        }
    }
    
    
//    @IBAction func closeButtonAction(_ sender: Any) {
//        // Closeボタンを押した時
//        hangUp()
//        _ = self.navigationController?.popToRootViewController(animated: true)
//    }
    
}




// MARK: - Peer Connection
extension MainScreenInteractor: RTCPeerConnectionDelegate {

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("\(#function): 接続情報交換の状況が変化した際に呼ばれます")
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        print("-- peer.onaddstream()")
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
    }
    
    
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        var state = ""
        switch (newState) {
        case RTCIceConnectionState.checking: state = "checking"
        case RTCIceConnectionState.completed: state = "completed"
        case RTCIceConnectionState.connected: state = "connected"
        case RTCIceConnectionState.closed:
            state = "closed"
            hangUp()
        case RTCIceConnectionState.failed:
            state = "failed"
            hangUp()
        case RTCIceConnectionState.disconnected: state = "disconnected"
        default: break
        }
        print("ICE connection Status has changed to \(state)")
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        if candidate.sdpMid != nil {
            sendIceCandidate(candidate)
        } else {
            print("empty ice event")
        }
    }
    
    
    func sendIceCandidate(_ candidate: RTCIceCandidate) {
        print("---sending ICE candidate ---")
        let jsonCandidate: JSON = ["type": "candidate",
                                    "ice": [
                                        "candidate": candidate.sdp,
                                        "sdpMLineIndex": candidate.sdpMLineIndex,
                                        "sdpMid": candidate.sdpMid!
                                        ]
                                    ]

        let message = jsonCandidate.dictionaryObject
        
        self.offerSignalRef?.setValue(message) { (error, ref) in
            if error != nil {
                print("Dang sendIceCandidate -->> ", error.debugDescription)
            }
        }
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
    }
    
}
