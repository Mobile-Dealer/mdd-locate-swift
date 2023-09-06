# MddLocateSDK

A description of this package.

### Swift Package Manager

1. Swift Package Manager is distributed with Xcode. To start adding the Amplify Libraries to your iOS project, open your project in Xcode 

2. Enter the MDD Library for the GitHub repo URL (`https://github.com/Mobile-Dealer/mdd-locate-swift`) into the search bar

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
    @State var detecting: Bool = false
    @State private var trackingTagId: String = "000107DB"

    var body: some View {
        VStack {
            Text("RSSI: \(rssi)").padding()
            TextField(
                "Tracking Tag ID",
                text: $trackingTagId
            )
            .textInputAutocapitalization(.characters)
            .padding()
            Button(action: {
                if (!self.detecting) {
                    detect(trackingTagId: trackingTagId.uppercased().replacingOccurrences(of: "O", with: "0"))
                    self.detecting.toggle()
                } else {
                    stopDetect(trackingTagId: trackingTagId.uppercased().replacingOccurrences(of: "O", with: "0"))
                    self.detecting.toggle()
                }
            }) {
                Text(self.detecting ? "Stop Detecting" : "Start Detecting")
            }
            .padding()
            .background((self.detecting) ? .red : .green)
            .disabled(trackingTagId.count != 8)
            .foregroundColor(.white)
            .cornerRadius(22)
        }
        .onAppear {
            // This will configure the MddLocateSDK with the given APIKEY
            MddLocateSDK.configure(apikey: "TESTING")
            // This does the background tracking does not currently push the data anywhere
            MddLocateSDK.startTrackingTags(username: "TESTING")
        }
        .padding()
        .textFieldStyle(.roundedBorder)
    }

    func detectWithTimer(trackingTagId: String) {
        print(trackingTagId)
        MddLocateSDK.startDetecting(trackingTagId: trackingTagId)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
           do {
               self.rssi = try MddLocateSDK.getDetectedRssi(trackingTagId: "000107DB")
               print(self.rssi)
           } catch {

           }
       })
    }

    func detect(trackingTagId: String) {
        print(trackingTagId)
        MddLocateSDK.startDetecting(trackingTagId: trackingTagId)
        subscription = NotificationCenter.default.publisher(for: MddLocateSDK.rssiNotification, object: nil)
            .sink(receiveValue: {
//                print($0.object as! Int)
                self.rssi = $0.object as! Int
            })

    }

    func stopDetect(trackingTagId: String) {
        subscription?.cancel()
        MddLocateSDK.stopDetecting(trackingTagId: trackingTagId)
        self.rssi = 0
    }

    func stopDetectingWithTimer(trackingTagId: String) {
        self.timer?.invalidate()
        self.timer = nil
        self.rssi = 0
        MddLocateSDK.stopDetecting(trackingTagId: trackingTagId)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

```
