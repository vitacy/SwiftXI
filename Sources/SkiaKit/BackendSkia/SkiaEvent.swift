
extension SC.InputState {
    func toEventType() -> NSEvent.EventType{
        var result = NSEvent.EventType.none
        switch self{
            case     .down:  result = .leftMouseDown 
            case     .up:  result = .leftMouseUp 
            case     .rightDown:  result = .rightMouseDown 
            case     .rightUp:  result = .rightMouseUp 
            case     .move: result = .mouseMoved 

            default: break
        }
        return result
    }
}

extension SC.ModifierKey{
    func toEventModifierFlags() -> NSEvent.ModifierFlags{
        var result = NSEvent.ModifierFlags.empty
        if (self.rawValue & Self.shift.rawValue) == 0{
            result = [result, .shift]
        }
        if (self.rawValue & Self.control.rawValue) == 0{
            result = [result, .control]
        }
        if (self.rawValue & Self.option.rawValue) == 0{
            result = [result, .option]
        }
        if (self.rawValue & Self.command.rawValue) == 0{
            result = [result, .command]
        }
        return result
    }
}