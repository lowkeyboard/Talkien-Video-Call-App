//
//  BottomSheet.swift
//  Talkien
//
//  Created by cagla copuroglu on 18.12.2021.
//
import UIKit

class BottomSheetViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        
        self.modalPresentationStyle = .pageSheet
      
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bRec:Bool = true
    
    @IBOutlet weak var btnRec: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
    }
    
    @IBAction func btnRec(_ sender: Any) {
        bRec = !bRec
        if bRec {
            btnRec.setImage(UIImage(named: "mic-on.png"), for: .normal)
        } else {
            btnRec.setImage(UIImage(named: "mic-off.png"), for: .normal)
        }
    }

    
}
