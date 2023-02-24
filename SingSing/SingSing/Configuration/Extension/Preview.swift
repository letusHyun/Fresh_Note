//
//  Preview.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/14.
//

import UIKit
import SwiftUI

//SwiftUI 활용해서 Preview 생성
//opt + Cmd + enter: 미리보기 창 열기
//opt + Cmd + P: 실행
#if DEBUG
extension UIViewController {
  private struct Preview: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
      return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
  }
  
  func toPreview() -> some View {
    Preview(viewController: self)
  }
}

extension UIView {
  private struct Preview: UIViewRepresentable {
    let view: UIView
    
    func makeUIView(context: Context) -> UIView {
      return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
  }
  
  func toPreview() -> some View {
    Preview(view: self)
  }
}
#endif
