# MddLocateSDK

A description of this package.

```swift
//
//  ContentView.swift
//  LocateTesting
//
//  Created by Ryan Vink on 8/29/23.
//

import SwiftUI
import LocateSDK
import Combine

struct ContentView: View {
    @State var rssi: Int = 0
    @State var subscription: AnyCancellable? = nil
    @State var timer: Timer? = nil
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("\(rssi)")
        }
        .onAppear {
            // This will configure the MddLocateSDK with the given APIKEY
            MddLocateSDK.configure(apikey: "TESTING")
            // This does the background tracking does not currently push the data anywhere
            MddLocateSDK.startTrackingTags(username: "TESTING")
            // This is for the beacon detecor
        }
        .padding()
    }
    
    func detectWithTimer(trackingTagId: String) {
        MddLocateSDK.startDetecting(trackingTagId: trackingTagId)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
           do {
               self.rssi = try MddLocateSDK.getDetectedRssi(trackingTagId: "000107DB")
           } catch {
               
           }
       })
    }

    func detect(trackingTagId: String) {
        subscription = NotificationCenter.default.publisher(for: MddLocateSDK.rssiNotification, object: nil)
            .sink(receiveValue: {
                print($0)
            })
        
    }
    
    func stopDetect(trackignTagId: String) {
        subscription?.cancel()
    }
    
    func stopDetectingWithTimer(trackingTagId: String) {
        self.timer?.invalidate()
        self.timer = nil
        MddLocateSDK.stopDetecting(trackingTagId: trackingTagId)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

```
