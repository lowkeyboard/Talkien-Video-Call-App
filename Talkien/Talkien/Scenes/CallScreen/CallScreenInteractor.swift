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


class CallScreenInteractor: NSObject, CallScreenInteractorProtocol, RTCDataChannelDelegate {
    
    func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
        debugPrint("dataChannel did change state: \(dataChannel.readyState)")

    }
    
    func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
        self.webRTCClient(self, didReceiveData: buffer.data)
    }
    
    func startRTCPeerConn() {
        
    }
    
    func webRTCClient(_ client: CallScreenInteractor, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        
    }
    
    func webRTCClient(_ client: CallScreenInteractor, didChangeConnectionState state: RTCIceConnectionState) {
        
    }
    
    func webRTCClient(_ client: CallScreenInteractor, didReceiveData data: Data) {
        
    }
    
    
    // The `RTCPeerConnectionFactory` is in charge of creating new RTCPeerConnection instances.
    // A new RTCPeerConnection should be created every new call, but the peerConnectionFactory is shared.
     static let peerConnectionFactory: RTCPeerConnectionFactory = {
        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        return RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }()

    
    
    weak var delegate: CallScreenInteractorDelegate?
 
    var peerConnection: RTCPeerConnection! = nil
    var audioSource: RTCAudioSource?
    let rtcAudioSession =  RTCAudioSession.sharedInstance()
    let audioQueue = DispatchQueue(label: "audio")
    let mediaConstrains = [kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueTrue,
                           kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueTrue]
    var videoCapturer: RTCVideoCapturer?
    var localVideoTrack: RTCVideoTrack?
    var remoteVideoTrack: RTCVideoTrack?
    var localDataChannel: RTCDataChannel?
    var remoteDataChannel: RTCDataChannel?


    var observerSignalRef: DatabaseReference? = nil
    var offerSignalRef: DatabaseReference? = nil
    

    var sender = NameProvider.sharedInstance.user_name
    var receiver = NameProvider.sharedInstance.channel_name

    
    func loadInteractor() {
        
        
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
    
    //MARK: Media --------------------------------------
    func startCaptureLocalVideo(renderer: RTCVideoRenderer) {
        guard let capturer = self.videoCapturer as? RTCCameraVideoCapturer else {
            return
        }

        guard
            let frontCamera = (RTCCameraVideoCapturer.captureDevices().first { $0.position == .front }),
        
            // choose highest res
            let format = (RTCCameraVideoCapturer.supportedFormats(for: frontCamera).sorted { (f1, f2) -> Bool in
                let width1 = CMVideoFormatDescriptionGetDimensions(f1.formatDescription).width
                let width2 = CMVideoFormatDescriptionGetDimensions(f2.formatDescription).width
                return width1 < width2
            }).last,
        
            // choose highest fps
            let fps = (format.videoSupportedFrameRateRanges.sorted { return $0.maxFrameRate < $1.maxFrameRate }.last) else {
            return
        }

        capturer.startCapture(with: frontCamera,
                              format: format,
                              fps: Int(fps.maxFrameRate))
        
        self.localVideoTrack?.add(renderer)
    }
    
    func renderRemoteVideo(to renderer: RTCVideoRenderer) {
        self.remoteVideoTrack?.add(renderer)
    }
    
    private func configureAudioSession() {
        self.rtcAudioSession.lockForConfiguration()
        do {
            try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
            try self.rtcAudioSession.setMode(AVAudioSession.Mode.voiceChat.rawValue)
        } catch let error {
            debugPrint("Error changeing AVAudioSession category: \(error)")
        }
        self.rtcAudioSession.unlockForConfiguration()
    }
    
    private func createMediaSenders() {
        let streamId = "stream"
        
        // Audio
        let audioTrack = self.createAudioTrack()
        self.peerConnection.add(audioTrack, streamIds: [streamId])
        
        // Video
        let videoTrack = self.createVideoTrack()
        self.localVideoTrack = videoTrack
        self.peerConnection.add(videoTrack, streamIds: [streamId])
        self.remoteVideoTrack = self.peerConnection.transceivers.first { $0.mediaType == .video }?.receiver.track as? RTCVideoTrack
        
        // Data
        if let dataChannel = createDataChannel() {
            dataChannel.delegate = self
            self.localDataChannel = dataChannel
        }
    }
    
    private func createAudioTrack() -> RTCAudioTrack {
        let audioConstrains = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        let audioSource = Talkien.CallScreenInteractor.peerConnectionFactory.audioSource(with: audioConstrains)
        let audioTrack = Talkien.CallScreenInteractor.peerConnectionFactory.audioTrack(with: audioSource, trackId: "audio0")
        return audioTrack
    }
    
    private func createVideoTrack() -> RTCVideoTrack {
        let videoSource = Talkien.CallScreenInteractor.peerConnectionFactory.videoSource()
        
        #if TARGET_OS_SIMULATOR
        self.videoCapturer = RTCFileVideoCapturer(delegate: videoSource)
        #else
        self.videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)
        #endif
        
        let videoTrack = Talkien.CallScreenInteractor.peerConnectionFactory.videoTrack(with: videoSource, trackId: "video0")
        return videoTrack
    }
    
    // MARK: Data Channels
    private func createDataChannel() -> RTCDataChannel? {
        let config = RTCDataChannelConfiguration()
        guard let dataChannel = self.peerConnection.dataChannel(forLabel: "WebRTCData", configuration: config) else {
            debugPrint("Warning: Couldn't create data channel.")
            return nil
        }
        return dataChannel
    }
    
    func sendData(_ data: Data) {
        let buffer = RTCDataBuffer(data: data, isBinary: true)
        self.remoteDataChannel?.sendData(buffer)
    }
    //MARK: Media --------------------------------------
    
    
    

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
    
    func prepareNewConnection() -> RTCPeerConnection {
        let configuration = RTCConfiguration()
        configuration.iceServers = [RTCIceServer.init(urlStrings: ["stun:stun.l.google.com:19302",
                                                                   "stun:stun2.l.google.com:19302",
                                                                   "stun:stun3.l.google.com:19302",
                                                                   "stun:stun4.l.google.com:19302"])]
        let constraints = RTCMediaConstraints(mandatoryConstraints:[
                                              "OfferToReceiveAudio": "true",
                                              "OfferToReceiveVideo": "true"],
                                              optionalConstraints: ["DtlsSrtpKeyAgreement":kRTCMediaConstraintsValueTrue])
        configuration.sdpSemantics = .unifiedPlan
        
        // gatherContinually will let WebRTC to listen to any network changes and send any new candidates to the other client
        configuration.continualGatheringPolicy = .gatherContinually

        self.peerConnection = Talkien.CallScreenInteractor.peerConnectionFactory.peerConnection(with: configuration, constraints: constraints, delegate: nil)

        return peerConnection
    }
    

    func sendOffer() {
        
        let configuration = RTCConfiguration()
        configuration.iceServers = [RTCIceServer.init(urlStrings: ["stun:stun.l.google.com:19302",
                                                                   "stun:stun2.l.google.com:19302",
                                                                   "stun:stun3.l.google.com:19302",
                                                                   "stun:stun4.l.google.com:19302"])]
        
        let constraints = RTCMediaConstraints(mandatoryConstraints:[
                                              "OfferToReceiveAudio": "true",
                                              "OfferToReceiveVideo": "true"],
                                              optionalConstraints: ["DtlsSrtpKeyAgreement":kRTCMediaConstraintsValueTrue])
        configuration.sdpSemantics = .unifiedPlan
        
        // gatherContinually will let WebRTC to listen to any network changes and send any new candidates to the other client
        configuration.continualGatheringPolicy = .gatherContinually

        self.peerConnection = Talkien.CallScreenInteractor.peerConnectionFactory.peerConnection(with: configuration, constraints: constraints, delegate: nil)
        
        self.createMediaSenders()
        self.configureAudioSession()
        self.peerConnection.delegate = self

        
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
                print("sending IceCandidate -->> ", error.debugDescription)
            }
        }
    }
    
    
    func setOffer(_ offer: RTCSessionDescription) {
        if peerConnection != nil {
            print("peerConnection has already exist!")
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
            print("peerConnection do not exist")
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
    

    
}


// MARK: - Peer Connection
extension CallScreenInteractor: RTCPeerConnectionDelegate, RTCVideoViewDelegate {
    func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
    
    }
    

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("\(#function)")
    }
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        print("didAdd stream")
        if stream.videoTracks.count > 0 {
            print("got video track")
            print(stream.videoTracks[0].isEnabled) //true geldi
            
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
