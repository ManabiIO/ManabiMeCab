// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ManabiMeCab",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ManabiMeCab", targets: ["ManabiMeCab"]),
        .library(name: "mecab", targets: ["mecab"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ManabiMeCab",
            dependencies: ["mecab"],
            resources: [
                .copy("Resources/ipadic/char.bin"),
                .copy("Resources/ipadic/dicrc"),
                .copy("Resources/ipadic/left-id.def"),
                .copy("Resources/ipadic/matrix.bin"),
                .copy("Resources/ipadic/pos-id.def"),
                .copy("Resources/ipadic/rewrite.def"),
                .copy("Resources/ipadic/right-id.def"),
                .copy("Resources/ipadic/sys.dic"),
                .copy("Resources/ipadic/unk.dic"),
                .copy("Resources/mecabrc"),
            ]
//            linkerSettings: [.linkedLibrary("mecab")]
        ),
        .target(name: "mecab", dependencies: [],
                path: "Sources/mecab/mecab",
                exclude: [
                    "src/mecab-cost-train.cpp", "src/mecab-dict-gen.cpp", "src/mecab-dict-index.cpp", "src/mecab-system-eval.cpp", "src/mecab-test-gen.cpp", "src/mecab.cpp", "src/make.bat", "src/Makefile.am", "src/Makefile.in", "src/Makefile.msvc.in", "csharp", "doc", "example", "java", "man", "misc", "perl", "python", "ruby", "swig", "tests", "aclocal.m4", "AUTHORS", "autogen.sh", "ChangeLog", "config.guess", "config.h.in", "config.rpath", "config.sub", "configure", "configure.in", "GPL", "INSTALL", "LGPL", "install-sh", "libtool", "ltmain.sh", "Makefile.am", "Makefile.in", "Makefile.train", "mecab-config.in", "mecab.iss.in", "mecabrc.in", "missing", "mkinstalldirs", "NEWS", "README", "stamp-h.in",
                ],
                sources: ["src"],
                resources: [.copy("BSD"), .copy("COPYING")],
                publicHeadersPath: "swift",
                cSettings: [.define("HAVE_CONFIG_H"),
                            .headerSearchPath(".")],
                cxxSettings: [.define("HAVE_ICONV")],
                swiftSettings: nil,
                linkerSettings: [.linkedLibrary("iconv")]),
        .testTarget(
            name: "ManabiMeCabTests",
            dependencies: ["ManabiMeCab"]),
    ]
)
