.pragma library
// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later

// Names of settings and categories, generated from OpenSCQ30 v2.12.0's
// lib/i18n/{en,de}/openscq30-lib.ftl (GPL-3.0-or-later).
// Keys are the camelCase ids used by the openscq30 CLI.

var names = {
 "de": {
  "acoustic": "Akustisch",
  "adaptive": "Adaptiv",
  "adaptiveNoiseCanceling": "Adaptive Geräuschunterdrückung",
  "adaptiveNoiseCancelingSensitivityLevel": "Adaptive Geräuschunterdrückung - Empfindlichkeitsniveau",
  "ambientSoundMode": "Umgebungsgeräusch-Modus",
  "autoPowerOff": "Automatisches Ausschalten",
  "bassBooster": "Bassverstärker",
  "bassReducer": "Bassreduzierer",
  "batteryLevel": "Batteriestand",
  "batteryLevelLeft": "Batteriestand (links)",
  "batteryLevelRight": "Batteriestand (rechts)",
  "bus": "Bus",
  "buttonConfiguration": "Tastenkonfiguration",
  "car": "Auto",
  "caseBatteryLevel": "Batteriestand (Hülle)",
  "charging": "Lädt",
  "classical": "Klassisch",
  "connected": "Verbunden",
  "custom": "Benutzerdefiniert",
  "customEqualizerProfile": "Benutzerdefiniertes Profil",
  "customNoiseCanceling": "Benutzerdefinierte Geräuschunterdrückung",
  "customProfile": "Benutzerdefiniertes Profil",
  "dance": "Tanz",
  "deviceInformation": "Geräteinformation",
  "disabled": "Deaktiviert",
  "disconnected": "Getrennt",
  "doublePress": "Doppeldruck",
  "electronic": "Elektronisch",
  "environmentDetection": "Umgebungserkennung",
  "equalizer": "Equalizer",
  "equalizerImportExport": "Equalizer Import/Export",
  "exportCustomEqualizerProfiles": "Benutzerdefinierte Profile exportieren",
  "firmwareVersion": "Firmware-Version",
  "firmwareVersionLeft": "Firmware-Version (links)",
  "firmwareVersionRight": "Firmware-Version (rechts)",
  "fullyTransparent": "Voll transparent",
  "gamingMode": "Game-Modus",
  "general": "Allgemein",
  "highNoise": "Hohe Lautstärke",
  "hipHop": "Hip Hop",
  "hostDevice": "Host-Gerät",
  "importCustomEqualizerProfiles": "Benutzdefinierte Profile importieren",
  "importCustomEqualizerProfilesConfirm": "Dies wird existierende Profile mit dem gleichen Namen überschreiben.",
  "indoor": "Innenbereich",
  "isCharging": "Wird geladen",
  "isChargingLeft": "Wird geladen (links)",
  "isChargingRight": "Wird geladen (rechts)",
  "jazz": "Jazz",
  "left": "Links",
  "leftDoublePress": "Doppeldruck links",
  "leftLongPress": "Langer Druck links",
  "leftSinglePress": "Einzeldruck links",
  "leftTriplePress": "Dreifachdruck links",
  "lounge": "Lounge",
  "lowNoise": "Niedrige Lautstärke",
  "manual": "Manuell",
  "manualNoiseCanceling": "Manuelle Geräuschunterdrückung",
  "manualTransparency": "Manuelle Transparenz",
  "mediumNoise": "Mittlere Lautstärke",
  "miscellaneous": "Verschiedenes",
  "moderate": "Mittel",
  "nextSong": "Nächstes Lied",
  "no": "Nein",
  "noiseCanceling": "Geräuschunterdrückung",
  "noiseCancelingMode": "Geräuschunterdrückungs-Modus",
  "none": "Nichts",
  "normal": "Normal",
  "notCharging": "Lädt nicht",
  "outdoor": "Außenbereich",
  "piano": "Klavier",
  "playPause": "Wiedergabe/Pause",
  "podcast": "Podcast",
  "pop": "Pop",
  "presetEqualizerProfile": "Voreinstellungs-Profil",
  "presetProfile": "Voreinstellungs-Profil",
  "previousSong": "Vorheriges Lied",
  "resetButtonsToDefault": "Tasten auf Standardeinstellungen zurücksetzen",
  "right": "Rechts",
  "rightDoublePress": "Doppeldruck rechts",
  "rightLongPress": "Langer Druck rechts",
  "rightSinglePress": "Einzeldruck rechts",
  "rightTriplePress": "Dreifachdruck rechts",
  "rock": "Rock",
  "serialNumber": "Seriennummer",
  "singlePress": "Einzeldruck",
  "smallSpeakers": "Kleine Lautsprecher",
  "soundModes": "Sound-Modi",
  "soundcoreA3004": "Soundcore Q20I",
  "soundcoreA3027": "Soundcore Life Q35",
  "soundcoreA3028": "Soundcore Q30 / Life Q30",
  "soundcoreA3029": "Soundcore Life Tune",
  "soundcoreA3030": "Soundcore Life Tune Pro",
  "soundcoreA3031": "Soundcore Vortex",
  "soundcoreA3033": "Soundcore Life 2 Neo",
  "soundcoreA3035": "Soundcore Space One",
  "soundcoreA3040": "Soundcore Space Q45",
  "soundcoreA3062": "Soundcore Space One Pro",
  "soundcoreA3116": "Soundcore Motion+",
  "soundcoreA3909": "Soundcore Liberty 2 Pro",
  "soundcoreA3926": "Soundcore Life Dot 2S",
  "soundcoreA3930": "Soundcore Liberty 2 Pro+",
  "soundcoreA3931": "Soundcore Life Dot 2 NC",
  "soundcoreA3933": "Soundcore Life Note 3",
  "soundcoreA3935": "Soundcore Life A2 NC",
  "soundcoreA3936": "Soundcore Space A40",
  "soundcoreA3939": "Soundcore Life P3",
  "soundcoreA3945": "Soundcore Life Note 3S",
  "soundcoreA3947": "Soundcore Liberty 4 NC",
  "soundcoreA3948": "Soundcore A20i",
  "soundcoreA3949": "Soundcore P20i / P25i / R50i",
  "soundcoreA3951": "Soundcore Liberty Air 2 Pro",
  "soundcoreA3952": "Soundcore Liberty 3 Pro",
  "soundcoreA3955": "Soundcore P40i",
  "soundcoreA3957": "Soundcore Liberty 5",
  "soundcoreA3959": "Soundcore P30i / R50i NC",
  "soundcoreDevelopment": "Soundcore Entwicklungsinformation",
  "soundcoreSignature": "Soundcore Signatur",
  "strong": "Stark",
  "touchTone": "Berührungston",
  "train": "Zug",
  "transparency": "Transparenz",
  "transparencyMode": "Transparenz-Modus",
  "transport": "Transport",
  "transportation": "Transport",
  "trebleBooster": "Höhenverstärker",
  "trebleReducer": "Höhenreduzierer",
  "vocalMode": "Stimmen-Modus",
  "voiceAssistant": "Sprachassistent",
  "volume": "Lautstärke",
  "volumeAdjustments": "Lautstärkeregelung",
  "volumeDown": "Lautstärke verringern",
  "volumeUp": "Lautstärke erhöhen",
  "weak": "Schwach",
  "windNoiseDetected": "Windgeräusche erkannt",
  "windNoiseSuppression": "Windgeräuschdämpfung",
  "yes": "Ja"
 },
 "en": {
  "acoustic": "Acoustic",
  "adaptive": "Adaptive",
  "adaptiveNoiseCanceling": "Adaptive Noise Canceling",
  "adaptiveNoiseCancelingSensitivityLevel": "Adaptive Noise Canceling Sensitivity Level",
  "airPressure": "Air Pressure",
  "airplaneMode": "Airplane Mode",
  "alarms": "Alarms",
  "ambientSoundMode": "Ambient Sound Mode",
  "ancPersonalizedToEarCanal": "ANC Personalized to Ear Canal",
  "atmospheric": "Atmospheric",
  "autoLightsOffMinutes": "Auto Lights Off (minutes)",
  "autoPlayPause": "Auto Play/Pause",
  "autoPowerOff": "Auto Power Off",
  "autoPowerOffPrompt": "Auto Power Off Prompt",
  "autoStopTimer": "Auto Stop Timer",
  "autoStopTimerDuration": "Auto Stop Timer Duration",
  "automaticUpdate": "Automatic Update",
  "balanced": "Balanced",
  "bassBooster": "Bass Booster",
  "bassOff": "Bass Off",
  "bassReducer": "Bass Reducer",
  "bassUp": "Bass Up",
  "batteryLevel": "Battery Level",
  "batteryLevelLeft": "Battery Level (Left)",
  "batteryLevelRight": "Battery Level (Right)",
  "bloom": "Bloom",
  "bluetooth": "Bluetooth",
  "breathing": "Breathing",
  "bus": "Bus",
  "buttonConfiguration": "Button Configuration",
  "buttonsEnabled": "Buttons Enabled",
  "car": "Car",
  "case": "Case",
  "caseBatteryLevel": "Case Battery Level",
  "caseFirmwareVersion": "Case Firmware Version",
  "caseLanguage": "Case Language",
  "caseSerialNumber": "Case Serial Number",
  "changeMode": "Change Mode",
  "charging": "Charging",
  "classic": "Classic",
  "classical": "Classical",
  "connected": "Connected",
  "custom": "Custom",
  "customEqualizerProfile": "Custom Profile",
  "customNoiseCanceling": "Custom Noise Canceling",
  "customProfile": "Custom Profile",
  "dance": "Dance",
  "dbLimit": "DB Limit",
  "dbRefreshRate": "DB Refresh Rate",
  "deep": "Deep",
  "defaultListeningMode": "Default Listening Mode",
  "deviceInformation": "Device Information",
  "disabled": "Disabled",
  "disconnected": "Disconnected",
  "dolbyAudio": "Dolby Audio",
  "doublePress": "Double Press",
  "dualConnections": "Dual Connections",
  "dualConnectionsDevices": "Dual Connections Devices",
  "easyChat": "Easy Chat",
  "easyChatWaitTime": "Easy Chat Wait Time",
  "electronic": "Electronic",
  "enabled": "Enabled",
  "environmentDetection": "Environment Detection",
  "equalizer": "Equalizer",
  "equalizerImportExport": "Equalizer Import/Export",
  "exportCustomEqualizerProfiles": "Export Custom Profiles",
  "exportCustomEqualizerProfilesOutput": "Export Custom Profiles Output",
  "findDevice": "Find Device",
  "firmest": "Firmest",
  "firmwareVersion": "Firmware Version",
  "firmwareVersionLeft": "Firmware Version (Left)",
  "firmwareVersionRight": "Firmware Version (Right)",
  "fixed": "Fixed",
  "flash": "Flash",
  "flat": "Flat",
  "friday": "Friday",
  "fullyTransparent": "Fully Transparent",
  "gaming": "Gaming",
  "gamingMode": "Gaming Mode",
  "general": "General",
  "glow": "Glow",
  "headTracking": "Head Tracking",
  "heavy": "Heavy",
  "highNoise": "High Noise",
  "hipHop": "Hip Hop",
  "hostDevice": "Host Device",
  "immersiveExperience": "Immersive Experience",
  "importCustomEqualizerProfiles": "Import Custom Profiles",
  "importCustomEqualizerProfilesConfirm": "This will overwrite existing profiles that share the same names.",
  "incomingCallsDuringBluetoothMode": "Incoming Calls During Bluetooth Mode",
  "indoor": "Indoor",
  "isCharging": "Is Charging",
  "isChargingLeft": "Is Charging (Left)",
  "isChargingRight": "Is Charging (Right)",
  "jazz": "Jazz",
  "latin": "Latin",
  "ldac": "LDAC",
  "left": "Left",
  "leftDoublePress": "Left Double Press",
  "leftLongPress": "Left Long Press",
  "leftSinglePress": "Left Single Press",
  "leftSlideDown": "Left Slide Down",
  "leftSlideUp": "Left Slide Up",
  "leftTriplePress": "Left Triple Press",
  "lightOn": "Light On",
  "lights": "Lights",
  "lightsBrightness": "Colorful Lights Brightness",
  "lightsColor": "Colorful Lights Color",
  "lightsEnabled": "Colorful Lights Enabled",
  "lightsMode": "Colorful Lights Mode",
  "limitHighVolume": "Limit High Volume",
  "limitHighVolumeDbLimit": "DB Limit",
  "limitHighVolumeRefreshRate": "DB Refresh Rate",
  "listeningMode": "Listening Mode",
  "listeningModePrompt": "Listening Mode Prompt",
  "local": "Local",
  "lounge": "Lounge",
  "lowBatteryPrompt": "Low Battery Prompt",
  "lowNoise": "Low Noise",
  "manual": "Manual",
  "manualNoiseCanceling": "Manual Noise Canceling",
  "manualTransparency": "Manual Transparency",
  "manualUpdate": "Manual Update",
  "medium": "Medium",
  "mediumNoise": "Medium Noise",
  "miscellaneous": "Miscellaneous",
  "moderate": "Moderate",
  "monday": "Monday",
  "movie": "Movie",
  "movieMode": "Movie Mode",
  "multiScene": "Multi-Scene",
  "multiSceneNoiseCanceling": "Multi-Scene Noise Canceling",
  "music": "Music",
  "musicFollows": "Music Follows",
  "nature": "Nature",
  "nextSong": "Next Song",
  "no": "No",
  "noiseCanceling": "Noise Canceling",
  "noiseCancelingMode": "Noise Canceling Mode",
  "noiseCancelingModeInCycle": "Noise Canceling Mode in Cycle",
  "noiseCancelingPrompt": "Noise Canceling Prompt",
  "none": "None",
  "normal": "Normal",
  "normalModeInCycle": "Normal Mode in Cycle",
  "notCharging": "Not Charging",
  "original": "Original",
  "outdoor": "Outdoor",
  "piano": "Piano",
  "plane": "Plane",
  "playPause": "Play Pause",
  "podcast": "Podcast",
  "pop": "Pop",
  "powerOff": "Power Off",
  "presetEqualizerProfile": "Preset Profile",
  "presetProfile": "Preset Profile",
  "pressureSensitivity": "Pressure Sensitivity",
  "previousSong": "Previous Song",
  "realTime": "Real Time",
  "realTimeAdaptiveNoiseCanceling": "Real Time Adaptive Noise Canceling",
  "remoteCamera": "Remote Camera",
  "resetButtonsToDefault": "Reset Buttons to Default",
  "rhythm": "Rhythm",
  "right": "Right",
  "rightDoublePress": "Right Double Press",
  "rightLongPress": "Right Long Press",
  "rightSinglePress": "Right Single Press",
  "rightSlideDown": "Right Slide Down",
  "rightSlideUp": "Right Slide Up",
  "rightTriplePress": "Right Triple Press",
  "rnb": "RnB",
  "rock": "Rock",
  "saturday": "Saturday",
  "sendPacket": "Send Packet",
  "serialNumber": "Serial Number",
  "sideTone": "Side Tone",
  "singlePress": "Single Press",
  "smallSpeakers": "Small Speakers",
  "softest": "Softest",
  "soundLeakCompensation": "Sound Leak Compensation",
  "soundModes": "Sound Modes",
  "soundcoreA3004": "Soundcore Q20I",
  "soundcoreA3027": "Soundcore Life Q35",
  "soundcoreA3028": "Soundcore Q30 / Life Q30",
  "soundcoreA3029": "Soundcore Life Tune",
  "soundcoreA3030": "Soundcore Life Tune Pro",
  "soundcoreA3031": "Soundcore Vortex",
  "soundcoreA3033": "Soundcore Life 2 Neo",
  "soundcoreA3035": "Soundcore Space One",
  "soundcoreA3040": "Soundcore Space Q45",
  "soundcoreA3062": "Soundcore Space One Pro",
  "soundcoreA3116": "Soundcore Motion+",
  "soundcoreA3876": "Soundcore V20i",
  "soundcoreA3909": "Soundcore Liberty 2 Pro",
  "soundcoreA3926": "Soundcore Life Dot 2S",
  "soundcoreA3930": "Soundcore Liberty 2 Pro+",
  "soundcoreA3931": "Soundcore Life Dot 2 NC",
  "soundcoreA3933": "Soundcore Life Note 3",
  "soundcoreA3935": "Soundcore Life A2 NC",
  "soundcoreA3936": "Soundcore Space A40",
  "soundcoreA3939": "Soundcore Life P3",
  "soundcoreA3944": "Soundcore Life P2 Mini",
  "soundcoreA3945": "Soundcore Life Note 3S",
  "soundcoreA3947": "Soundcore Liberty 4 NC",
  "soundcoreA3948": "Soundcore A20i",
  "soundcoreA3949": "Soundcore P20i / P25i / R50i",
  "soundcoreA3951": "Soundcore Liberty Air 2 Pro",
  "soundcoreA3952": "Soundcore Liberty 3 Pro",
  "soundcoreA3954": "Soundcore Liberty 4 Pro",
  "soundcoreA3955": "Soundcore P40i",
  "soundcoreA3957": "Soundcore Liberty 5",
  "soundcoreA3959": "Soundcore P30i / R50i NC",
  "soundcoreA3968": "Soundcore Sport X20",
  "soundcoreD1101": "Soundcore C50i",
  "soundcoreD1202": "Soundcore P31i",
  "soundcoreD1202c": "Soundcore R60i NC",
  "soundcoreD1301": "Soundcore Sleep A30",
  "soundcoreDevelopment": "Soundcore Development Information",
  "soundcoreSignature": "Soundcore Signature",
  "spatialAudio": "Spatial Audio",
  "spatialAudioMode": "Spatial Audio Mode",
  "spatialAudioMusicMode": "Spatial Audio Music Mode",
  "spokenWord": "Spoken Word",
  "stateUpdatePacket": "State Update Packet",
  "strong": "Strong",
  "sunday": "Sunday",
  "surroundSound": "Surround Sound",
  "talkMode": "Talk Mode",
  "thursday": "Thursday",
  "touchLock": "Touch Lock",
  "touchTone": "Touch Tone",
  "train": "Train",
  "transparency": "Transparency",
  "transparencyMode": "Transparency Mode",
  "transparencyModeInCycle": "Transparency Mode in Cycle",
  "transport": "Transport",
  "transportation": "Transportation",
  "transportationMode": "Transportation Mode",
  "trebleBooster": "Treble Booster",
  "trebleReducer": "Treble Reducer",
  "tuesday": "Tuesday",
  "twsStatus": "True Wireless (TWS) Status",
  "vocalMode": "Vocal Mode",
  "voice": "Voice",
  "voiceAssistant": "Voice Assistant",
  "voicePrompt": "Voice Prompt",
  "volume": "Volume",
  "volumeAdjustments": "Volume Adjustments",
  "volumeBalance": "Volume Balance",
  "volumeBooster": "Volume Booster",
  "volumeDown": "Volume Down",
  "volumeUp": "Volume Up",
  "weak": "Weak",
  "wearingDetection": "Wearing Detection",
  "wearingTone": "Wearing Tone",
  "wednesday": "Wednesday",
  "windNoiseDetected": "Wind Noise Detected",
  "windNoiseSuppression": "Wind Noise Suppression",
  "yes": "Yes"
 }
}

function _lang() {
    var l = Qt.locale().name.substring(0, 2)
    return names[l] ? l : "en"
}

// "ambientSoundMode" -> "Ambient sound mode"
function prettify(id) {
    if (!id) return ""
    var s = String(id).replace(/([a-z0-9])([A-Z])/g, "$1 $2").toLowerCase()
    return s.charAt(0).toUpperCase() + s.slice(1)
}

function name(id) {
    var l = _lang()
    if (names[l][id]) return names[l][id]
    if (names.en[id]) return names.en[id]
    return prettify(id)
}

// Makes a setting value readable for labels.
function formatValue(value) {
    if (value === undefined || value === null || value === "") return "\u2013"
    if (typeof value === "boolean") return value ? "\u2713" : "\u2717"
    if (Array.isArray(value)) return value.join(", ")
    return String(value)
}

// ---- device form factors (for the illustrations) ------------------------

var _overEar = ["SoundcoreA3004", "SoundcoreA3027", "SoundcoreA3028", "SoundcoreA3029",
                "SoundcoreA3030", "SoundcoreA3031", "SoundcoreA3033", "SoundcoreA3035",
                "SoundcoreA3040", "SoundcoreA3062"]
var _speaker = ["SoundcoreA3116"]

// "inear" | "overear" | "speaker"
function formFactor(modelId) {
    if (_overEar.indexOf(modelId) >= 0) return "overear"
    if (_speaker.indexOf(modelId) >= 0) return "speaker"
    return "inear"
}

// Image file for a model; large=true shows earbuds in their charging case.
function deviceImage(modelId, large) {
    var f = formFactor(modelId)
    return (large && f === "inear") ? "case" : f
}

// Finds the model whose name matches a Bluetooth device name (or "").
function guessModel(bluetoothName, modelNames) {
    if (!bluetoothName || !modelNames) return ""
    var bt = String(bluetoothName).toLowerCase()
    var best = "", bestLength = 0
    for (var id in modelNames) {
        var name = String(modelNames[id]).toLowerCase()
        if ((bt.indexOf(name) >= 0 || name.indexOf(bt) >= 0) && name.length > bestLength) {
            best = id
            bestLength = name.length
        }
    }
    return best
}

// ---- battery ------------------------------------------------------------

// The CLI reports battery levels as "level/max", e.g. "4/5" -> 80
function batteryPercent(value) {
    var m = /^(\d+)\s*\/\s*(\d+)$/.exec(String(value))
    if (!m || parseInt(m[2]) === 0) return -1
    // some OpenSCQ30 modules add an offset of 1 to the level: never show more than 100 %
    return Math.max(0, Math.min(100, Math.round(parseInt(m[1]) * 100 / parseInt(m[2]))))
}

// Yes/no values: the CLI reports e.g. the charging state as "Yes"/"No"
// (not "true"/"false"). Returns true, false, or null if it is not a yes/no value.
function yesNo(value) {
    if (value === true || value === false) return value
    var v = String(value).toLowerCase()
    if (v === "true" || v === "yes") return true
    if (v === "false" || v === "no") return false
    return null
}

// "4/5" -> { level: 4, max: 5 } (or null). Many devices only report 5 steps.
function batteryLevel(value) {
    var m = /^(\d+)\s*\/\s*(\d+)$/.exec(String(value))
    if (!m || parseInt(m[2]) === 0) return null
    var max = parseInt(m[2])
    return { level: Math.max(0, Math.min(max, parseInt(m[1]))), max: max }
}

// Readable text for read-only values: battery levels as percent, single-word
// values from the CLI ("Connected", "Left", ...) translated if possible.
function formatInformation(settingId, value) {
    if (/battery/i.test(settingId)) {
        var p = batteryPercent(value)
        if (p >= 0) return p + " %"
    }
    if (typeof value === "string" && /^[A-Za-z]+$/.test(value)) {
        var key = value.charAt(0).toLowerCase() + value.slice(1)
        var l = _lang()
        if (names[l][key]) return names[l][key]
    }
    return formatValue(value)
}

// ---- additions to the upstream translations ------------------------------
// German names missing in OpenSCQ30's openscq30-lib.ftl (plus one typo fix).
(function() {
    var de = {
        limitHighVolume: "Lautstärkebegrenzung",
        limitHighVolumeDbLimit: "dB-Grenze",
        limitHighVolumeRefreshRate: "dB-Aktualisierungsrate",
        soundLeakCompensation: "Klangverlust-Ausgleich",
        surroundSound: "Surround-Sound",
        autoPlayPause: "Automatische Wiedergabe/Pause",
        wearingTone: "Trageton",
        touchLock: "Berührungssperre",
        lowBatteryPrompt: "Hinweis bei schwachem Akku",
        wearingDetection: "Trageerkennung",
        importCustomEqualizerProfiles: "Benutzerdefinierte Profile importieren",
        exportCustomEqualizerProfilesOutput: "Exportierte Profile",
        realTime: "Echtzeit",
        // new in OpenSCQ30 2.9.0
        "case": "Ladehülle",
        leftSlideUp: "Nach oben wischen links",
        leftSlideDown: "Nach unten wischen links",
        rightSlideUp: "Nach oben wischen rechts",
        rightSlideDown: "Nach unten wischen rechts",
        airplaneMode: "Flugmodus",
        atmospheric: "Atmosphäre",
        remoteCamera: "Kamera-Fernauslöser",
        findDevice: "Gerät finden",
        spatialAudio: "Räumliches Audio",
        spatialAudioMode: "Modus für räumliches Audio",
        spatialAudioMusicMode: "Musikmodus für räumliches Audio",
        caseLanguage: "Sprache der Ladehülle",
        caseSerialNumber: "Seriennummer der Ladehülle",
        caseFirmwareVersion: "Firmware-Version der Ladehülle",
        airPressure: "Luftdruck",
        easyChat: "Easy Chat",
        easyChatWaitTime: "Easy-Chat-Wartezeit",
        dualConnections: "Doppelverbindung",
        dualConnectionsDevices: "Verbundene Geräte",
        // new in OpenSCQ30 2.10 – 2.12
        lights: "Beleuchtung",
        realTimeAdaptiveNoiseCanceling: "Adaptive Geräuschunterdrückung in Echtzeit",
        volumeBalance: "Lautstärkebalance",
        lightsEnabled: "Farbige Beleuchtung",
        lightsBrightness: "Helligkeit der Beleuchtung",
        lightsColor: "Farbe der Beleuchtung",
        lightsMode: "Beleuchtungsmodus",
        autoLightsOffMinutes: "Beleuchtung automatisch aus (Minuten)",
        buttonsEnabled: "Tasten aktiviert",
        autoPowerOffPrompt: "Hinweis vor dem Ausschalten",
        listeningModePrompt: "Ansage des Hörmodus",
        incomingCallsDuringBluetoothMode: "Anrufe im Bluetooth-Modus",
        noiseCancelingPrompt: "Ansage der Geräuschunterdrückung",
        autoStopTimer: "Automatischer Stopp-Timer",
        autoStopTimerDuration: "Dauer des Stopp-Timers",
        alarms: "Wecker",
        listeningMode: "Hörmodus",
        defaultListeningMode: "Standard-Hörmodus"
    }
    for (var k in de)
        names.de[k] = de[k]
})()

// Short explanations shown below some switches.
var descriptions = {
    en: {
        limitHighVolume: "Limits the level to protect your hearing.",
        gamingMode: "Lower latency for games and videos.",
        exportCustomEqualizerProfiles: "Choose the profiles to export.",
        dualConnections: "Connect the headphones to two devices at the same time.",
        dualConnectionsDevices: "Devices known to the headphones. Long press to remove one."
    },
    de: {
        limitHighVolume: "Begrenzt den Pegel, um das Gehör zu schonen.",
        gamingMode: "Geringere Latenz bei Spielen und Videos.",
        exportCustomEqualizerProfiles: "Wähle die Profile, die exportiert werden sollen.",
        dualConnections: "Kopfhörer gleichzeitig mit zwei Geräten verbinden.",
        dualConnectionsDevices: "Geräte, die die Kopfhörer kennen. Gedrückt halten, um eines zu entfernen."
    }
}

function description(id) {
    var l = _lang()
    if (descriptions[l] && descriptions[l][id]) return descriptions[l][id]
    return (descriptions.en[id]) || ""
}
