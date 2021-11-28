import CoreGraphics

public struct keypress {
    enum KeyError: Error {
        case KeyNotFound
    }

    private static func check(_ key: String) throws {
        let key = key.lowercased()

        guard keyCode[key] != nil else {
            throw KeyError.KeyNotFound
        }
    }

    private static func docheck(_ key: String) {
        do {
            try check(key)
        } catch KeyError.KeyNotFound {
            print("Key not found.")
        } catch {
            print("Unknown error.")
        }
    }

    public static func press (_ key: String) {
        docheck(key)

        let key = key.lowercased()

        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

        let key_down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[key]!), keyDown: true)
        let key_up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[key]!), keyDown: false)

        let loc = CGEventTapLocation.cghidEventTap

        key_down?.post(tap: loc)
        key_up?.post(tap: loc)

    }

    public static func hotkey(_ with: String, _ key: String) {
        docheck(with)
        docheck(key)

        let key = key.lowercased()
        let with = with.lowercased()

        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

        let key_down_with = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[with]!), keyDown: true)
        let key_up_with = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[with]!), keyDown: false)
        let key_down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[key]!), keyDown: true)
        let key_up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[key]!), keyDown: false)

        switch(with) {
            case "command", "⌘":
            key_down?.flags = CGEventFlags.maskCommand
            case "option", "⌥":
            key_down?.flags = CGEventFlags.maskAlternate
            case "shift", "⇧":
            key_down?.flags = CGEventFlags.maskShift
            case "control", "⌃", "ctrl":
            key_down?.flags = CGEventFlags.maskControl
            case "function", "fn":
            key_down?.flags = CGEventFlags.maskSecondaryFn
            case "capslock":
            key_down?.flags = CGEventFlags.maskAlphaShift
            default:
            print("\(with) key is not supported.")
        }

        let loc = CGEventTapLocation.cghidEventTap

        key_down_with?.post(tap: loc)
        key_down?.post(tap: loc)
        key_up?.post(tap: loc)
        key_up_with?.post(tap: loc)
    }

    // Determine if a key is pressed.
    // If it is pressed, return true, else return false.
    public static func isPressed(_ key: String) -> Bool {
        docheck(key)

        let key_lower = key.lowercased()
        let key_code: CGKeyCode = CGKeyCode(keyCode[key_lower]!)
        let isPressed: Bool = CGEventSource.keyState(.combinedSessionState, key: key_code)
        return isPressed
    }

}
