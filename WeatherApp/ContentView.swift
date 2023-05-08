//
//  ContentView.swift
//  WeatherApp
//
//  Created by userext on 05/05/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Spacer()
            HStack(alignment: .center, spacing: 50) {
                Image(systemName: "sun.max.fill")
                    .font(.largeTitle)
                Text("27º")
                    .font(.largeTitle)
            }
            Text("Sunny outside.\nDon't forget your hat!")
                .font(.body)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*

 curl --compressed --request GET --url \
 'https://api.tomorrow.io/v4/timelines?location=40.75872069597532,-73.98529171943665&fields=temperature&timesteps=1h&units=metric&apikey=rGQBRaNgwSwHTignYBOXTOnCtG9pikn3'
 */
