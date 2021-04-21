//
//  TableView+Extension.swift
//  JSwift
//
//  Created by jps on 2021/4/21.
//

import Foundation
import UIKit

extension UITableView {
    
//    open override class func load() {
//        <#code#>
//    }
    
//    open override class func initialize() {
//        <#code#>
//    }
    
//    class func f() {
//        aClass.self
//        let c = self.classForCoder()
//        self.self
//        UITableView.self
//    }
//
//    func f() {
//        let c: AnyClass = type(of: self)
//
//    }
    
    
//    class func f() {
//        let m: Method = class_getInstanceMethod(<#T##cls: AnyClass?##AnyClass?#>, <#T##name: Selector##Selector#>)
//    }
    
}


/*
 + (void)load
 {
     [self swizzledSelector:@selector(SCIndexView_layoutSubviews) originalSelector:@selector(layoutSubviews)];
 }

 + (void)swizzledSelector:(SEL)swizzledSelector originalSelector:(SEL)originalSelector
 {
     Class class = [self class];
     Method originalMethod = class_getInstanceMethod(class, originalSelector);
     Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
     BOOL didAddMethod =
     class_addMethod(class,
                     originalSelector,
                     method_getImplementation(swizzledMethod),
                     method_getTypeEncoding(swizzledMethod));
     if (didAddMethod) {
         class_replaceMethod(class,
                             swizzledSelector,
                             method_getImplementation(originalMethod),
                             method_getTypeEncoding(originalMethod));
     } else {
         method_exchangeImplementations(originalMethod, swizzledMethod);
     }
 }

 - (void)SCIndexView_layoutSubviews {
     [self SCIndexView_layoutSubviews];
     
     if (!self.sc_indexView) {
         return;
     }
     if (self.superview && !self.sc_indexView.superview) {
         [self.superview addSubview:self.sc_indexView];
     }
     else if (!self.superview && self.sc_indexView.superview) {
         [self.sc_indexView removeFromSuperview];
     }
     if (!CGRectEqualToRect(self.sc_indexView.frame, self.frame)) {
         self.sc_indexView.frame = self.frame;
     }
     [self.sc_indexView refreshCurrentSection];
 }

 */
