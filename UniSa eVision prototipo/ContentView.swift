import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView{
            ContentCameraView()
                .tabItem{
                    Label("Recognize Buildings", systemImage: "camera")
                }
            ListBuildingView()
                .tabItem {
                    Label("Buildings", systemImage: "list.dash")
                }
        }
    }
}


struct ViewChanger<Destination>: View where Destination: View{
    let destination: Destination
    let label: String
    
    var body: some View {
        NavigationView {
            NavigationLink(
                destination: destination,
                label: {
                    Text(label)
                        .foregroundColor(Color.white)
                        .padding()
                }
            )
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat(30)))
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
