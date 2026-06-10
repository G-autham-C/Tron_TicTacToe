import AVFoundation
import Observation

@Observable final class SoundManager {
    static let shared = SoundManager()

    private let engine = AVAudioEngine()
    private let mixer = AVAudioMixerNode()
    private let sampleRate: Double = 44100
    private let format: AVAudioFormat

    private init() {
        format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!
        engine.attach(mixer)
        engine.connect(mixer, to: engine.mainMixerNode, format: nil)
        try? engine.start()
    }

    private func playTone(frequency: Float, duration: Double, amplitude: Float = 0.5) {
        let player = AVAudioPlayerNode()
        engine.attach(player)
        engine.connect(player, to: mixer, format: format)

        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            engine.detach(player)
            return
        }

        buffer.frameLength = frameCount
        let fadeStart = Int(Float(frameCount) * 0.8)

        for ch in 0..<Int(format.channelCount) {
            let data = buffer.floatChannelData![ch]
            for i in 0..<Int(frameCount) {
                var sample = amplitude * sin(2 * .pi * frequency * Float(i) / Float(sampleRate))
                if i >= fadeStart {
                    let fadeProgress = Float(i - fadeStart) / Float(Int(frameCount) - fadeStart)
                    sample *= 1.0 - fadeProgress
                }
                data[i] = sample
            }
        }

        player.scheduleBuffer(buffer, completionHandler: nil)
        player.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.1) {
            self.engine.detach(player)
        }
    }

    func playMove() {
        playTone(frequency: 880, duration: 0.08, amplitude: 0.4)
    }

    func playWin() {
        playTone(frequency: 523, duration: 0.12)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
            self.playTone(frequency: 659, duration: 0.12)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
            self.playTone(frequency: 784, duration: 0.18)
        }
    }

    func playLose() {
        playTone(frequency: 392, duration: 0.15)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            self.playTone(frequency: 294, duration: 0.20)
        }
    }

    func playDraw() {
        playTone(frequency: 220, duration: 0.20, amplitude: 0.3)
    }
}
