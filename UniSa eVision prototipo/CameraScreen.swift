//
//  CameraScreen.swift
//  UniSa eVision prototipo
//
//  Created by Benedetto on 16/02/23.
//
import SwiftUI
import AVFoundation

class ViewController: UIViewController {
    
    //variabili
    private let captureSession = AVCaptureSession()
    
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    //quando la view viene ricaricata, bisogna restartare
    //la fotocamera
    func reloadView(){
        if (startCaptureSession()) {
            debugPrint("Sessione di cattura avviata.")
        }
    }

    //al caricamento della view...
    override func viewDidLoad(){
        super.viewDidLoad()
        /* rimuovi layers prima dell'avvio, in via precauzionale */
        removeLayers()
        if (tryAddCameraInput() == true) {
            if (startCaptureSession()) {
                debugPrint("Sessione di cattura avviata.")
            }
        } else {
            //Mostrare un messaggio di errore all'utente? @Giancarlo - 16.02.2023
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        //Bisognerebbe fare una cosa del genere per spegnere la camera quando l'utente
        //preme "back", anche se... sembra non funzionare.
        //@Giancarlo - 16.02.2023
        super.viewWillDisappear(animated)
        if (stopCaptureSession() ) {
            debugPrint("Sessione di cattura correttamente interrotta.")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.frame
    }
    
    // helper function
    
    //creazione input camera
    private func tryAddCameraInput() -> Bool{
        
        //inizializzazione device con le caratteristiche
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],
            mediaType: .video,
            position: .back
        ).devices.first else {
            fatalError("No camera: utilizzare un dispositivo fisico, non un simulatore")
        }
        
        
        //prendi input dal device
        let cameraInput = try? AVCaptureDeviceInput(device: device)
        
        if (cameraInput == nil) {
            debugPrint("Camerainput is nil" )
            return false;
        }
        
        if captureSession.canAddInput(cameraInput!) {
            // passaggio alla capture session
            captureSession.addInput(cameraInput!)
        } else {
            debugPrint("Impossibile aggiungere cameraInput alla sessione di cattura" )
            return false;
        }
        
        return true;
    }
    
    private func showCameraFeed(){
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.frame
    }
    
    
    /* ================================
     * Capture session utilities
     * ================================ */
    
    private func removeLayers() -> Void {
        if let sublayers = self.view.layer.sublayers {
            for sublayer in sublayers {
                if sublayer.isKind(of: AVCaptureVideoPreviewLayer.self) {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    // Gestire le sessioni di cattura in modo asincrono
    // non grava sul thread principale, che dovrebbe occuparsi
    // solo di aggiornare l'interfaccia utente e poco altro.
    private func stopCaptureSession() -> Bool {
        if captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
            }
            removeLayers()
            
            return true;
        } else {
            debugPrint("Nessuna camera session in corso... non c'è niente da stoppare.")
            return false;
        }
    }
    
    private func startCaptureSession() -> Bool {
        if captureSession.isRunning {
            debugPrint("Attenzione! Una camera session è già in corso!")
            return false;
        } else {
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
            
            showCameraFeed()
            
            
            return true;
        }
    }
}

/* ================================
 * View
 * ================================ */
struct CameraView: UIViewRepresentable {
    
    let viewController: ViewController = ViewController()
    
    //quando la view viene ricaricata
    func reloadView(){
        viewController.reloadView()
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Nothing to do here
    }
}

struct ContentCameraView : View {
    let cameraView : CameraView = CameraView()
    var body: some View {
           cameraView
                //quando la view appare viene automaticamente restartata la fotocamera
                //tramite il metodo reloadView
               .onAppear {
                   cameraView.reloadView()
               }
       }
}

class PreviewView: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

