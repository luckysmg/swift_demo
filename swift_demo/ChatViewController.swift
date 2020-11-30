//
//  Test.swift
//  iOSTest
//
//  Created by luckysmg on 2020/10/20.
//

import Foundation
import UIKit
import SwiftUI


class MessageTableView: UITableView {
    
    var onTouch:(()->Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.onTouch?()
    }
}


class ChatViewController : UIViewController,UITextFieldDelegate{
    
    var tableView = MessageTableView()
    var data = ["123","12323","1213"]
    
    lazy var textField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "send message"
        tf.backgroundColor = .white
        tf.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        tf.returnKeyType = .send
        tf.delegate = self
        return tf
    }()

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.data.append(textField.text ?? "")
        tableView.insertRows(at: [IndexPath(row: self.data.count-1, section: 0)], with: .left)
        textField.text = ""
        if(self.data.count != 0){
            let indexPath = IndexPath(row: self.data.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
        self.tableView.contentInset = .zero
        return true
    }
    
    lazy var bottomBar:UIView = {
        let bottomBar = StickyBottomKeyBoardView(frame: .zero, controllerView: self.view)
        bottomBar.backgroundColor = .blue
        return bottomBar
    }()
  
    var keyboardY:CGFloat = 0.0
    @objc func keyboardWillChangeFrame(note:Notification){
        
        guard let userInfo = note.userInfo,let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as?CGRect else { return }
        
        let bottomViewNewFrame = (note.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let newY = UIScreen.main.bounds.height - bottomViewNewFrame.origin.y
        
        //判断这次的y值是否和上次一样，如果一样说明是拦截，直接返回
        //就不走下面逻辑了
        if(newY == keyboardY){
            return
        }
        
        keyboardY = newY
        
        let convertFrame = view.convert(frame, from: UIScreen.main.coordinateSpace)
        
        let interHeight = view.frame.intersection(convertFrame).height
        tableView.contentInset.bottom = interHeight
        UIView.animate(withDuration: 0.4) {
            if(self.data.count != 0){
                let indexPath = IndexPath(row: self.data.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "聊天"
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(note:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tableView)
        view.addSubview(bottomBar)
        bottomBar.addSubview(textField)
        
        
        textField.snp.makeConstraints { (mkr) in
            mkr.left.right.equalToSuperview().inset(10)
            mkr.top.equalToSuperview().inset(10)
            mkr.height.equalTo(40)
        }
        
        bottomBar.snp.makeConstraints { (mkr) in
            mkr.bottom.width.equalToSuperview()
            mkr.height.equalTo(89)
        }
        

        //在触摸的时候进行焦点移除
        self.tableView.onTouch = {[weak self] in
            self?.view.endEditing(true)
        }
    
        tableView.snp.makeConstraints { (mkr) in
            mkr.top.equalToSuperview()
            mkr.width.equalToSuperview()
            mkr.bottom.equalTo(self.bottomBar.snp.top)
        }
    }
}

extension ChatViewController:UITableViewDataSource,UITableViewDelegate{
    
        
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
 
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRow!!")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        return cell
    }
}



#if DEBUG
import SwiftUI

struct ChatPreview : PreviewProvider{
    static var previews: some View{
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container : UIViewControllerRepresentable {
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
        func makeUIViewController(context: Context) -> UIViewController {
            ChatViewController()
        }
    }
}
#endif




