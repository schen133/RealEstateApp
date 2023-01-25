//
//  ImageView.swift
//  NewDigs
//
//  Created by Sifeng Chen on 11/6/22.
//
import SwiftUI
import UIKit
 struct ImageView: View {
    var apartmentDataForZoom: Apartment
    
     var body: some View{
        GeometryReader { proxy in
        Image(imageData: apartmentDataForZoom.image, placeholder: "rochester")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .modifier(TapAndDrag(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
        }

    }
 }

struct TapAndDrag: ViewModifier {
    private var contentSize: CGSize
    private var min: CGFloat = 1.0
    private var max: CGFloat = 3.0
    @State var currentScale: CGFloat = 1.0

    init(contentSize: CGSize) {
        self.contentSize = contentSize
    }
    
    var doubleTapGesture: some Gesture {
        TapGesture(count: 2).onEnded {
            if currentScale <= min { currentScale = max } else
            if currentScale >= max { currentScale = min } else {
                currentScale = ((max - min) * 0.5 + min) < currentScale ? max : min
            }
        }
    }
    
    func body(content: Content) -> some View {
        ScrollView([.horizontal, .vertical]) {
            content
                .frame(width: contentSize.width * currentScale, height: contentSize.height * currentScale, alignment: .center)
        }
        .gesture(doubleTapGesture)
        .animation(.easeInOut, value: currentScale)
    }
}


