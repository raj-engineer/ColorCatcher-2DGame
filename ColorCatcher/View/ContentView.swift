//
//  ContentView.swift
//  ColorCatcher
//
//  Created by Rajesh Rajesh on 21/04/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var scene = GameScene()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Game Scene
            SpriteView(scene: self.scene)
                .ignoresSafeArea()
            // Score View
            scoreView()
        }.alert(isPresented: $scene.isEnabled) {
            scene.showAlert()
        }
    }
    
    private func scoreView() -> some View {
        HStack() {
            Text("Score : \(scene.currentScore)")
                .font(.headline)
                .padding()
            Spacer()
            Text("HighScore : \(scene.highScore)")
                .font(.headline)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
