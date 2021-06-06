//
//  ViewController.swift
//  pairprogramming
//
//  Created by Taeheon Woo on 2021/06/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

fileprivate func makeLabel(with text: String) -> UILabel {
  let label = UILabel()
  label.text = text
  
  return label
}

class TicTokViewController: UIViewController {
  struct Text {
    static let driver = "Driver"
    static let navigator = "Navigator"
    static let `switch` = "SWITCH"
  }
  
  /// 남은 시간을 알려주는 라벨
  private let timeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.text = "00:00"
    
    return label
  }()
  
  private let leftRoleLabel = makeLabel(with: Text.driver)
  private let rightRoleLabel = makeLabel(with: Text.navigator)
  
  /// 역할 변경을 해주는 버튼
  private let switchButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .blue
    button.setTitle("SWITCH", for: .normal)
    
    return button
  }()
  
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setConstraints()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let orientation = UIInterfaceOrientation.landscapeRight.rawValue
    UIDevice.current.setValue(orientation, forKey: "orientation")
    UINavigationController.attemptRotationToDeviceOrientation()
  }
  
  private func addSubviews() {
    view.addSubview(timeLabel)
    view.addSubview(switchButton)
    view.addSubview(leftRoleLabel)
    view.addSubview(rightRoleLabel)
  }
  
  private func setConstraints() {
    addSubviews()
    
    timeLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    switchButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(timeLabel.snp.bottom).offset(52)
    }
    
    leftRoleLabel.snp.makeConstraints { make in
      make.trailing.equalTo(timeLabel.snp.leading).offset(-48)
      make.bottom.equalTo(timeLabel.snp.centerY).offset(-50)
    }
    
    rightRoleLabel.snp.makeConstraints { make in
      make.leading.equalTo(timeLabel.snp.trailing).offset(48)
      make.bottom.equalTo(timeLabel.snp.centerY).offset(-50)
    }
  }
  
  private func bind() {
    switchButton.rx.tap.asObservable()
      .bind(to: self.rx.switchRole)
      .disposed(by: disposeBag)
  }
  
  func switchRole() {
    if leftRoleLabel.text == Text.driver {
      leftRoleLabel.text = Text.navigator
      rightRoleLabel.text = Text.driver
      return
    }
    
    leftRoleLabel.text = Text.driver
    rightRoleLabel.text = Text.navigator
  }
}

fileprivate extension Reactive where Base: TicTokViewController {
  var switchRole: Binder<Void> {
    return Binder(self.base) { viewController, _ in
      viewController.switchRole()
    }
  }
}
