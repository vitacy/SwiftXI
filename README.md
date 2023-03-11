# swiftxi

build skia for win10
`
cd ThirdParty
git clone https://github.com/google/skia
cd skia
python3 tools/git-sync-deps
#bin/fetch-ninja
#bin/fetch-gn

bin\gn gen out/ClangCl  --args="is_debug=false extra_cflags=[\"/MD\"] clang_win=\"C:/Library/Developer/Toolchains/unknown-Asserts-development.xctoolchain/usr\""
ninja -C out/ClangCl HelloWorld
`

`
nm -gUj /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/SwiftUI.framework/SwiftUI | xcrun swift-demangle | sed 's/SwiftUI.//g' | sed 's/Swift.//g'
`


