//
//  VideoEditController.swift
//  swift_demo
//
//  Created by luckysmg on 2020/12/1.
//

import UIKit
import AVFoundation


let screeenHeight = UIScreen.main.bounds.size.height
let screeenWidth = UIScreen.main.bounds.size.width

class VideoEditController:UIViewController {
    
    //获取到的视频文件
    private let asset:AVAsset
    
    //播放器
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
        self.view.backgroundColor = UIColor(r: 30, g: 30, b: 30)
        initTopToolBar()
        initPlayerView()
    }
}

//MARK: initPlayer:初始化播放器，布局播放器View
extension VideoEditController{
    func initPlayerView() {
        //装播放器layer的view
        let playerView = UIView()
        self.view.addSubview(playerView)
        //获取状态栏高度
        guard let statusBarHeight = UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.size.height else {
           return
        }
        playerView.frame = .init(x: 0, y: statusBarHeight, width: self.view.frame.width, height: screeenHeight / 2)
        let playerlayer = AVPlayerLayer(player: self.player)
        playerView.layer.addSublayer(playerlayer)
        playerlayer.frame = playerView.bounds
        player.seek(to:CMTime(value: 1, timescale: asset.duration.timescale))
    }
}


extension VideoEditController{
    //MARK: 布局顶部工具栏，返回，导出等
    func initTopToolBar(){
        
        
        
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

