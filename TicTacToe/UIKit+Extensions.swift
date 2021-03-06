//
//  UIKit+Extensions.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 11/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
    static var reuseIdentifier: String {get}
}
extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadableView: class {
    static var nibName: String {get}
}
extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReusableView, NibLoadableView {}
extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

extension UICollectionView {
//    func deque<T: UICollectionViewCell>(for type: T.Type, for indexPath: IndexPath) -> T {
//        if let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T {
//            return cell
//        }
//        
//        self.register(T.self)
//        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
//    }
}
