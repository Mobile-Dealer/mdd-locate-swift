# MddLocateSDK

This Mobile Dealer Data package will allow you to integrate our asset tracking platform into your SwiftUI project.  Allowing you to add the tracking tag asset tracking functionality into your app.  Please reach out to support@mdd.io with any questions!

### Adding MddLocateSKD package to your app through Swift Package Manager
##### Swift Package Manager is distributed with Xcode. To start adding the Libraries to your iOS project:

1. Open your project in Xcode
2. Navigate to `File` then `Add Packages...`

3. Enter the MDD Library for the GitHub repo URL (`https://github.com/Mobile-Dealer/mdd-locate-swift`) into the search bar
<img width="840" alt="Screenshot 2023-09-07 at 7 48 15 AM" src="https://github.com/Mobile-Dealer/mdd-locate-swift/assets/98433737/a782465e-ea83-4605-8c69-106f6a22cfa7">


4. Click "Add Package"
<img width="648" alt="Screenshot 2023-09-07 at 7 49 14 AM" src="https://github.com/Mobile-Dealer/mdd-locate-swift/assets/98433737/94d81780-282f-41c0-8e97-d25c8fe503e8">

5. Check the box for MddLocateSDK
<img width="649" alt="Screenshot 2023-09-07 at 7 49 49 AM" src="https://github.com/Mobile-Dealer/mdd-locate-swift/assets/98433737/38a9072d-800d-4069-9ab2-8689e4100a9a">

6. Click "Add Package"

##### Thats it!  Now you are ready to test the MddLocateSDK within your own app!



### Example code using MddLocateSDK
```swift
//
//  ContentView.swift
//  LocateTesting
//
//  Created by Mobile Dealer Data, LLC
//  Confidential 
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
