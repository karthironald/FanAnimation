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
    @State var currentAnimation = Animation.linear
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            ZStack {
                Circle() // Large circle over the wings
                    .stroke(Color.green, lineWidth: 10)
                    .frame(width: 270, height: 270)
                Fan() // Rotor with wings. Rotating part.
                    .fill(Color.green)
                    .frame(width: 250, height: 250)
                    .rotationEffect(shouldAnimate ? .degrees(angle) : .degrees(0))
                    .animation(currentAnimation.speed(speed)) // .repeatForever(autoreverses: false) is not working as expected. So went with timer and adding angle manually
                    .onAppear(perform: {
                        self.shouldAnimate = true
                    })
                    .onReceive(timer) { (_) in
                        self.angle += 90
                    }
            }
            
            Capsule(style: .continuous) // Vertical bar which is between fan rotor and control buttons
                .fill(Color.green)
                .frame(width: 20, height: 150)
                .offset(x: 0, y: -5)
                .zIndex(-1)
            
            HStack(spacing: 10) { // Fan control buttons
                
                Button(action: { // Stop button
                    self.timer.upstream.connect().cancel()
                    self.speed = 0.2 / self.speed
                    self.currentAnimation = Animation.spring() // Changing animation type to get the smooth stopping animation and to obey physics 😅
                }) {
                    Text("S")
                        .bold()
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                .background(Color.red)
                .mask(Circle())
                
                Button(action: { // Low speed button
                    self.timer = Timer.publish(every: 0.2, on: .main, in: .default).autoconnect()
                    self.speed = 0.2
                    self.currentAnimation = Animation.linear
                }) {
                    Text("L")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .mask(Circle())
                
                Button(action: { // Medium speed button
                    self.timer = Timer.publish(every: 0.05, on: .main, in: .default).autoconnect()
                    self.speed = 0.05
                    self.currentAnimation = Animation.linear
                }) {
                    Text("M")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .mask(Circle())
                
                Button(action: { // High speed button
                    self.timer = Timer.publish(every: 0.02, on: .main, in: .default).autoconnect()
                    self.speed = 0.02
                    self.currentAnimation = Animation.linear
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

struct ContentView_Previews: PreviewProvider { // Preview might not work. Build and run to get some air from fan.
    static var previews: some View {
        ContentView()
    }
}


struct Fan: Shape { // Fan rotor(rotating part)
    
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


struct Wing: Shape { // Fan wings
    
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
