//
//  ContentView.swift
//  Fan
//
//  Created by Karthick Selvaraj on 18/06/20.
//  Copyright © 2020 Mallow Technologies Private Limited. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var speed = 0.1
    @State var timer = Timer.publish(every: 500, on: .main, in: .default).autoconnect()
    @State var angle: Double = 0
    @State var shouldAnimate = false
    @State var ani = Animation.linear
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color.green, lineWidth: 10)
                    .frame(width: 270, height: 270)
                Fan()
                    .fill(Color.green)
                    .frame(width: 250, height: 250)
                    .rotationEffect(shouldAnimate ? .degrees(angle) : .degrees(0))
                    .animation(ani.speed(speed))
                    .onAppear(perform: {
                        self.shouldAnimate = true
                    })
                    .onReceive(timer) { (_) in
                        self.angle += 90
                    }
            }
            Capsule(style: .continuous)
                .fill(Color.green)
                .frame(width: 20, height: 150)
                .offset(x: 0, y: -5)
                .zIndex(-1)
            HStack(spacing: 10) {
                Button(action: {
                    self.timer.upstream.connect().cancel()
                    self.speed = 0.2 / self.speed
                    self.ani = Animation.spring()
                }) {
                    Text("S")
                        .bold()
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                .background(Color.red)
                .mask(Circle())
                
                Button(action: {
                    self.timer = Timer.publish(every: 0.2, on: .main, in: .default).autoconnect()
                    self.speed = 0.2
                    self.ani = Animation.linear
                }) {
                    Text("L")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .mask(Circle())
                Button(action: {
                    self.timer = Timer.publish(every: 0.05, on: .main, in: .default).autoconnect()
                    self.speed = 0.05
                    self.ani = Animation.linear
                }) {
                    Text("M")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .mask(Circle())
                Button(action: {
                    self.timer = Timer.publish(every: 0.02, on: .main, in: .default).autoconnect()
                    self.speed = 0.02
                    self.ani = Animation.linear
                }) {
                    Text("H")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .mask(Circle())
            }
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .offset(x: 0, y: -10)
            Spacer()
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Fan: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: 20, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        
        path.move(to: CGPoint(x: rect.midX, y: rect.midY - 30))
        path.addPath(Wing().path(in: rect))
        
        path.move(to: CGPoint(x: rect.midX, y: rect.midY + 30))
        path.addPath(Wing().rotation(.degrees(240)).path(in: rect))
        
        path.move(to: CGPoint(x: rect.midX + 30, y: rect.midY))
        path.addPath(Wing().rotation(.degrees(120)).path(in: rect))
        
        path.move(to: CGPoint(x: rect.midX - 30, y: rect.midY))
        
        return path
    }
}

struct Wing: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX - 20, y: rect.midY - 20))
        path.addQuadCurve(to: CGPoint(x: rect.midX + 20, y: rect.midY - 20), control: CGPoint(x: rect.midX, y: rect.midY - 40))
        path.addLine(to: CGPoint(x: rect.midX + 40, y: rect.midY / 8))
        path.addQuadCurve(to: CGPoint(x: rect.midX - 40, y: rect.midY / 8), control: CGPoint(x: rect.midX, y: 0))
        path.closeSubpath()
        
        return path
    }
    
}
