//
//  NumericReadout.swift
//  Tactile Totals
//
//  Created by Steven M. Caruso on 2/23/24.
//

import SwiftUI

struct NumericReadout: View {
    
    @State public var buffer: String?
    
    var body: some View {
        
        Text( buffer ?? "BASEBALL" )
			.font(.custom("Big", size: 35))
			.fontDesign(.monospaced)
			.padding(EdgeInsets(top: 25, leading: 65, bottom: 25, trailing: 65))
			.glassBackgroundEffect()
    }
    
}

#Preview {
    NumericReadout()
}
