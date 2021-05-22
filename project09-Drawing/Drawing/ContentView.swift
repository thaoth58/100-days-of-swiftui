//
//  ContentView.swift
//  Drawing
//
//  Created by Thao Truong on 22/05/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var loadingPercent = 0.0
    
    var body: some View {
        ZStack {
            Arrow()
                .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .padding()
                .onTapGesture {
                    withAnimation(.linear(duration: 3)) {
                        loadingPercent = 1
                    }
                }
            
            Arrow(loadingPercent: loadingPercent)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .padding()
        }
    }
}

// Just test, not optimized
struct Arrow: Shape {
    let headAmount: CGFloat = 40
    
    var loadingPercent: Double = 1
    
    var animatableData: Double {
        get { loadingPercent }
        set { self.loadingPercent = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if loadingPercent == 0 {
            return path
        }
        
        var lineInset = CGFloat(loadingPercent * 1.25)
        
        if lineInset > 1 {
            lineInset = 1
        }
        
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX * lineInset, y: rect.midY))
        
        if (loadingPercent > 0.8) {
            let loadingHead = CGFloat((loadingPercent - 0.8) * 5) * headAmount
            
            path.addLine(to: CGPoint(x: rect.maxX - loadingHead, y: rect.midY - loadingHead))
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX - loadingHead, y: rect.midY + loadingHead))
        }
        
        return path
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
