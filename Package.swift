    // swift-tools-version:6.0
    import PackageDescription

    let package = Package(
        name: "SideMenuKit",
        platforms: [.iOS(.v17)],
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
