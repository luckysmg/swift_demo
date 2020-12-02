//
//  VideoEditController.swift
//  swift_demo
//
//  Created by luckysmg on 2020/12/1.
//

import UIKit
import AVFoundation

class VideoEditController:UIViewController {
    private let asset:AVAsset
    lazy var player: AVPlayer = {
        let player = AVPlayer(playerItem: AVPlayerItem(asset: self.asset))
        return player
    }()
    
    init(asset:AVAsset){
        self.asset = asset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPlayer()
        let urlasset = self.asset as! AVURLAsset
        print(urlasset.url)
    }
}

//MARK: View:
extension VideoEditController{
    func initPlayer() {
        let playerlayer = AVPlayerLayer(player: self.player)
        self.view.layer.addSublayer(playerlayer)
        playerlayer.frame = self.view.bounds
        player.play()
    }
}


#if DEBUG
import SwiftUI

struct VideoEditPreview : PreviewProvider{
    static var previews: some View{
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container : UIViewControllerRepresentable {
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
        func makeUIViewController(context: Context) -> UIViewController {
            let previewPath = Bundle.main.path(forResource: "asset", ofType: "MOV")
            let asset = AVURLAsset(url:URL(fileURLWithPath: previewPath!))
            return VideoEditController(asset:asset)
        }
    }
}
#endif

