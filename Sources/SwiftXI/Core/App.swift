//
//  App.swift
//  SwiftUI
//
//  Created by hello on 2022/5/5.
//
@_exported import Foundation
@_exported import SkiaKit

public protocol App {
    associatedtype Body: Scene
    @SceneBuilder var body: Self.Body { get }
    init()
}

extension App {
    public static func main() {
        let app = Self()
        print("Hello, App \(app)")
        NSApplication.shared.delegate = _AppDelegate.init(app)
        NSApplication.shared.run()
        print("Hello, Loop End!")        
    }
}



