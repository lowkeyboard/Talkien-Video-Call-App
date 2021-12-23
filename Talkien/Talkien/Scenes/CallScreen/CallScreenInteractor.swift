//
//  CallScreenInteractor.swift
//  Talkien
//
//  Created by cagla copuroglu on 16.12.2021.
//

import AVFoundation
import WebRTC
import FirebaseDatabase
import SwiftyJSON


class CallScreenInteractor: NSObject, CallScreenInteractorProtocol {
    
    weak var delegate: CallScreenInteractorDelegate?

 
    var peerConnectionFactory: RTCPeerConnectionFactory! = nil
    var peerConnection: RTCPeerConnection! = nil
    var audioSource: RTCAudioSource?
    var videoSource: RTCVideoSource?
    var Source: RTCCameraVideoCapturer?
    
    var video_rtc: RTCVideoRenderer?
    
    var remote_rtc: RTCEAGLVideoView?
    var local_rtc: RTCCameraPreviewView?
    
    var observerSignalRef: DatabaseReference? = nil
    var offerSignalRef: DatabaseReference? = nil
    

    var sender = NameProvider.sharedInstance.user_name
    var receiver = NameProvider.sharedInstance.channel_name

    
    func loadInteractor() {
        self.peerConnectionFactory = RTCPeerConnectionFactory()
        
        self.startRTCPeerConn()
        self.setupFirebase()
        
        observerSignalRef = Database.database().reference()
    }
    
    
    func setupFirebase() {
        
        // https://ttalkien-default-rtdb.firebaseio.com/Call/
        
        self.observerSignalRef = Database.database().reference().child("Call/\(receiver)")
        self.offerSignalRef = Database.database().reference().child("Call/\(sender)")
        
        self.offerSignalRef?.onDisconnectRemoveValue()
        self.observerSignal()
    }
    
    
    deinit {
        if peerConnection != nil {
            hangUp()
        }
        audioSource = nil
        videoSource = nil
        peerConnectionFactory = nil
    }
    

    //retrieving from database snapsohot
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
    
    
    func startRTCPeerConn() { //both audio and video
        let audioSourceConstraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        audioSource = peerConnectionFactory.audioSource(with: audioSourceConstraints)
        
        let videoSourceConstraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        videoSource = peerConnectionFactory.videoSource()
        
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
        
        let localAudioTrack = peerConnectionFactory.audioTrack(with: audioSource!, trackId: "LOCAL_AUDIO_TRACK")
        let audioSender = peerConnection.sender(withKind: kRTCMediaStreamTrackKindAudio, streamId: "REMOTE_AUDIO_TRACK")
        audioSender.track = localAudioTrack
        
        let localMediaTrack = peerConnectionFactory.videoTrack(with: videoSource!, trackId: "LOCAL_VIDEO_TRACK")
        let videoSender = peerConnection.sender(withKind: kRTCMediaStreamTrackKindVideo, streamId: "LOCAL_VIDEO_TRACK")
        videoSender.track = localMediaTrack
        
        
        return peerConnection
    }
    

    
    func sendOffer() {
        
        peerConnection = prepareNewConnection()
        
        let constraints = RTCMediaConstraints(mandatoryConstraints:
            [
            "OfferToReceiveAudio": "true",
            "OfferToReceiveVideo": "true"],
    
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
        
        self.peerConnection.answer(for: constraints, completionHandler: answerCompletion)
    }
    
    
    func sendSDP(_ desc: RTCSessionDescription) {
        print("---sending sdp ---")
        
        let jsonSdp: JSON = [
            "sdp": desc.sdp,
            "type": RTCSessionDescription.string(for: desc.type)
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
        
        
        peerConnection = prepareNewConnection()
        self.peerConnection.setRemoteDescription(offer, completionHandler: {(error: Error?) in
            if error == nil {
                print("setRemoteDescription(offer) success")
                self.makeAnswer()
            } else {
                print("setRemoteDescription(offer) ERROR: " + error.debugDescription)
            }
        })
    }
    
    
    func setAnswer(_ answer: RTCSessionDescription) {
        if peerConnection == nil {
            print("peerConnection do not exist :(")
            return
        }
        
        self.peerConnection.setRemoteDescription(answer, completionHandler: {
            (error: Error?) in
            if error == nil {
                print("setRemoteDescription(answer) success")
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
    
    func setRemoteView(remoteView: RTCEAGLVideoView) {
        self.remote_rtc = remoteView
    }
    
    func setLocalView(localView: RTCCameraPreviewView){
        
        if let frame = self.local_rtc?.frame {
            let rtcVideoView = RTCCameraPreviewView.init(frame: CGRect.init())
            print("frame isnt empty")
            rtcVideoView.frame = frame
            rtcVideoView.frame.origin.x = 0
            rtcVideoView.frame.origin.y = 0
            localView.captureSession.startRunning()
            localView.addSubview(rtcVideoView)
            self.local_rtc = localView

        } else {
            print("frame is empty")

        }
        
    }
    
    
}


// MARK: - Peer Connection
extension CallScreenInteractor: RTCPeerConnectionDelegate, RTCVideoViewDelegate {
    func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
//        videoView.setSize(.init(width: 100, height: 100))
    
    }
    

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("\(#function)")
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        print("didAdd stream")
        if stream.videoTracks.count > 0 {
            print("got video track")
            print(stream.videoTracks[0].isEnabled) //true geldi
//            stream.videoTracks[0].add(self.video_rtc!) empty 
        }
        
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
    }
    
    
    ///** Called when negotiation is needed, for example ICE has restarted. */
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
