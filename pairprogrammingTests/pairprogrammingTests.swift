//
//  pairprogrammingTests.swift
//  pairprogrammingTests
//
//  Created by Taeheon Woo on 2021/06/06.
//

import UIKit
import Quick
import Nimble
@testable import pairprogramming

class TicTokViewControllerSpec: QuickSpec {
  override func spec() {
    describe("TicTokViewController") {
      var ticTokViewController: TicTokViewController!
      
      beforeEach {
        ticTokViewController = TicTokViewController()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = ticTokViewController
        
        ticTokViewController.beginAppearanceTransition(true, animated: false)
        ticTokViewController.endAppearanceTransition()
      }
      
      context("when did appeared") {
        it("renders role labels") {
          let labels = ticTokViewController.view.subviews
            .compactMap {  $0 as? UILabel }
          
          let hasDriver = labels.contains { $0.text == "Driver" }
          let hasNavigator = labels.contains { $0.text == "Navigator" }
          
          expect(hasDriver && hasNavigator).to(beTrue())
        }
        
        it("renders time label") {
          let timeLabel = ticTokViewController.view.subviews
            .compactMap { $0 as? UILabel }
            .filter { label in
              label.text?.contains(":") == true
            }.first
          
          expect(timeLabel).notTo(beNil())
        }
        
        it("renders switch button and listen tap") {
          // render
          let switchButton = ticTokViewController.view.subviews
            .compactMap { $0 as? UIButton }
            .first { $0.titleLabel?.text == "SWITCH" }
          
          expect(switchButton).notTo(beNil())
          
          // listen
          let driverButton = ticTokViewController.view.subviews
            .compactMap { $0 as? UILabel }
            .first { $0.text == "Driver" }
          
          switchButton?.sendActions(for: .touchUpInside)
          
          expect(driverButton?.text).to(be("Navigator"))
        }
      }
    }
  }
}
