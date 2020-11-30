//
//  StickyKeyBoardView.swift
//  swift_douban
//
//  Created by luckysmg on 2020/5/17.
//  Copyright © 2020 luckysmg. All rights reserved.
//

import UIKit

//吸附在底部和键盘同升降的view封装，在外部需要先添加到屏幕底部，剩下的交给此view处理即可
class StickyBottomKeyBoardView: UIView {
    var controllerView:UIView?
    
    init(frame: CGRect,controllerView:UIView) {
        super.init(frame: frame)
        self.controllerView = controllerView
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func keyboardWillChangeFrame(note:Notification){
        let duration = note.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        let bottomViewNewFrame = (note.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let newY = UIScreen.main.bounds.height - bottomViewNewFrame.origin.y
        self.snp.updateConstraints { (mkr) in
            mkr.bottom.equalToSuperview().offset(-newY)
        }
        UIView.animate(withDuration: duration) {
            self.controllerView?.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
