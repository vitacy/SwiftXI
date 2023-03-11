extension View {
     public func foregroundColor(_ color: Color?) -> some View {
        return environment(\._foregroundColor, color)
    }
}

struct _ForegroundColorKey: EnvironmentKey {
    static var defaultValue: Color? {
        return nil
    }
}
extension EnvironmentValues {
    var _foregroundColor: Color? {
        get { return self[_ForegroundColorKey.self] }
        set { self[_ForegroundColorKey.self] = newValue }
    }
}