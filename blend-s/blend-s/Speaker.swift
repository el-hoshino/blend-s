//
//  Speaker.swift
//  blend-s
//
//  Created by 史翔新 on 2017/11/29.
//  Copyright © 2017年 史 翔新. All rights reserved.
//

import Foundation
import Cocoa

private let voiceName = NSSpeechSynthesizer.VoiceName(rawValue: "com.apple.speech.synthesis.voice.tessa")

class Speaker {
	
	private let speechSynthesizer: NSSpeechSynthesizer
	
	init() {
		
		let synthesizer = NSSpeechSynthesizer(voice: voiceName) ?? {
			assertionFailure("Failed to make NSSpeechSynthesizer with VoiceName: \(voiceName)")
			return NSSpeechSynthesizer()
		}()
		
		synthesizer.rate *= 1.2
		
		self.speechSynthesizer = synthesizer
		
	}
	
}

extension Speaker {
	
	func say(_ sentence: String) {
		self.speechSynthesizer.stopSpeaking()
		self.speechSynthesizer.startSpeaking(sentence)
	}
	
}
