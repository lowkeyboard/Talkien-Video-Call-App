//
//
//

import AVFoundation
import WebRTC
import Firebase


final class MainScreenInteractor: NSObject,  MainScreenInteractorProtocol {

    weak var delegate: MainScreenInteractorDelegate?
    weak var rtcdelegate: RTCPeerConnectionDelegate?
    
    
    var peerconnection: RTCPeerConnection?
    var myIceCandidate: RTCIceCandidate?
    private var myIceServers: [RTCIceServer] = []
    var myRtcConfig: RTCConfiguration?
    var myFactory: RTCPeerConnectionFactory?
    var myMediaConst: RTCMediaConstraints?
    var mediaStream: RTCMediaStream!
    
    var sesh: RTCSessionDescription?
    
    
    //Initializing the RTCPeerConnection
    func startRTCPeerConn() {
        RTCInitializeSSL()
        
        myFactory = RTCPeerConnectionFactory()
        myRtcConfig = RTCConfiguration()
        let iceStunServer1 = "stun:stun1.l.google.com:19302"
        let iceStunServer2 = "stun:stun2.l.google.com:19302"
        
        myIceServers.append(RTCIceServer(urlStrings: [iceStunServer1, iceStunServer2]))
        
        myRtcConfig?.iceServers = myIceServers
        print(peerconnection?.iceConnectionState as Any)
        
        //MARK: - func to Building media streams from tracks (editle)

        self.peerconnection = self.myFactory?.peerConnection(with: myRtcConfig!, constraints: myMediaConst!, delegate: rtcdelegate)
        
        self.myMediaConst = RTCMediaConstraints(
            mandatoryConstraints:[
                "OfferToReceiveAudio" : "true",
                "OfferToReceiveVideo" : "false"],
            optionalConstraints: [
                "" : "",
            ])
        print(self.peerconnection?.connectionState)
        
        let myAudioTrack = self.myFactory?.audioTrack(withTrackId: "AUDIO_TRACK_ID")
        mediaStream =  self.myFactory?.mediaStream(withStreamId: "LOCAL_MEDIA_STREAM_ID")
        mediaStream.addAudioTrack(myAudioTrack!)
        
        //MARK: - func to Creating the offer with ICE candidates (editle)
        self.peerconnection?.offer(for: myMediaConst!)
        print(peerconnection?.iceGatheringState)
        print(peerconnection?.iceConnectionState)


    }
    
    //func to Building media streams from tracks
    //func to Creating the offer with ICE candidates
    
    
    func selectMovie(at index: Int) {
//        let movie = movies[index]
//        delegate?.handleOutput(.showCallScreen(movie))
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

}

extension MainScreenInteractor: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("stateChanged: RTCSignalingState")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        print("didAdd stream: RTCMediaStream")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        print("")
    }
    
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        print("peerConnectionShouldNegotiate")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        print("newState: RTCIceConnectionState")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        print("")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        print("didGenerate candidate: RTCIceCandidate")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        print("")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        print("")
    }
    
    
}
