//
//  MenuScrollViewController.swift
//  MyTodoList
//
//  Created by 牧内秀介 on 2020/10/09.
//  Copyright © 2020 古府侑樹. All rights reserved.
//

import UIKit
import Foundation

import EventKit
import RealmSwift

class MenuScrollViewController: UIViewController, UIScrollViewDelegate {
    // 指が画面に触れ、スクロールが開始した瞬間に呼ばれる
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    // スクロール中に呼ばれる
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
    }
    // 指が画面から離れた瞬間に呼ばれる
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scrollViewWillEndDragging withVelocity velocity targetContentOffset")
    }
    // 指が画面から離れた瞬間に呼ばれる
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewWillBeginDragging willDecelerate decelerate")
    }
    // 指が画面から離れ、慣性のスクロールになる瞬間に呼ばれる
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    // 指が画面から離れ、慣性のスクロールが完全に止まる瞬間に呼ばれる
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
}
