
# MddLocateSDK Documentation

Welcome to the MddLocateSDK documentation. This SDK allows you to integrate the Mobile Dealer Data asset tracking platform into your SwiftUI project, enabling tracking tag asset functionality in your app. If you have any questions, please don't hesitate to contact us at [support@mdd.io](mailto:support@mdd.io).

## Initial Setup

### 1. Adding the MddLocateSDK Package

To integrate MddLocateSDK into your project using the Swift Package Manager:

1. **Open your project in Xcode**.
2. Navigate to `File` → `Add Packages...`.
3. In the search bar, enter the GitHub repo URL for the MDD Library: `https://github.com/Mobile-Dealer/mdd-locate-swift`.

   ![MDD Library Search](https://github.com/Mobile-Dealer/mdd-locate-swift/assets/98433737/a782465e-ea83-4605-8c69-106f6a22cfa7)

4. Click "Add Package".
   
   ![Add Package](https://github.com/Mobile-Dealer/mdd-locate-swift/assets/98433737/94d81780-282f-41c0-8e97-d25c8fe503e8)

5. Ensure the checkbox for `MddLocateSDK` is selected.

   ![Select SDK](https://github.com/Mobile-Dealer/mdd-locate-swift/assets/98433737/38a9072d-800d-4069-9ab2-8689e4100a9a)

6. Click "Add Package" again.

### 2. Setting Up Required Permissions

To ensure your app functions correctly with the MddLocateSDK:

1. **Open your app's `Info.plist`**.
2. Add a new entry with the key `NSLocationWhenInUseUsageDescription`.
3. Set the value to a string describing why your app needs location access. For instance:

   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>We use your location to provide beacon scanning functionality related to vehicles in your vicinity.</string>
   ```

### 3. Enabling Required Capabilities

1. Open your project settings by clicking on the project name in the Project Navigator.
2. Select the app target from the list of targets.
3. Navigate to the "Signing & Capabilities" tab.
4. Click the `+ Capability` button and add `Background Modes`.
<img width="882" alt="Screenshot 2023-09-07 at 10 09 18 AM" src="https://github.com/Mobile-Dealer/mdd-locate-swift/assets/98433737/a142eba9-891f-4fa4-bd6b-d1b501b257aa">


5. In the "Background Modes" section, check the boxes for `Location updates` and `Uses Bluetooth LE accessories`.
<img width="1268" alt="Screenshot 2023-09-07 at 11 40 36 AM" src="https://github.com/Mobile-Dealer/mdd-locate-swift/assets/98433737/0f0b823e-b9f4-451a-a2c0-9d98e2676b2a">



### 4. Importing Necessary Libraries

In the SwiftUI views or other Swift files where you intend to use the MddLocateSDK, make sure to import the required libraries:

```swift
import SwiftUI
import LocateSDK
import Combine
```

## Example Usage

Here's a sample SwiftUI view that demonstrates how to use the MddLocateSDK:

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
