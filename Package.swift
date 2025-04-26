    // swift-tools-version:5.9
    import PackageDescription

    let package = Package(
        name: "SideMenuKit",
        platforms: [.iOS(.v15)],
        products: [
            .library(
                name: "SideMenuKit",
                targets: ["SideMenuKit"]
            )
        ],
        targets: [
            .target(
                name: "SideMenuKit",
                dependencies: []
            )
        ]
    )
