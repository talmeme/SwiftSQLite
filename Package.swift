// swift-tools-version:5.9
import PackageDescription

#if os(macOS)
var csqlcipherUnsafeFlags = ["-L/opt/local/lib"]
var sqlcipherCSetting = ["-I/opt/local/include/openssl-3"]
#endif
#if os(Linux)
    #if arch(x86_64)
var csqlcipherUnsafeFlags = ["-L/usr/lib/x86_64-linux-gnu"]
    #endif
    #if arch(arm64)
var csqlcipherUnsafeFlags = ["-L/usr/lib/aarch64-linux-gnu"]
    #endif
var sqlcipherCSetting = ["-I/usr/include"]
#endif

let package = Package(
    name: "SwiftSQLite",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftSQLite",
            targets: ["SwiftSQLite"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SQLite3", // Keep the name to avoid source changes in SwiftSQLite.
            cSettings: sqlcipherCSettings,
            linkerSettings: [
                .linkedLibrary("crypto"),
                .unsafeFlags(csqlcipherUnsafeFlags)
            ]
        ),
        .target(
            name: "SwiftSQLite",
            dependencies: [
                .target(name: "SQLite3"),
            ]),
        .testTarget(
            name: "SwiftSQLiteTests",
            dependencies: ["SwiftSQLite"]),
    ]
)

var sqlcipherCSettings: [CSetting] { [
    // Use OpenSSL for SQLcipher
    .unsafeFlags(sqlcipherCSetting),
    .define("SQLITE_HAS_CODEC"),
    .define("SQLITE_TEMP_STORE", to: "2"),
    // Derived from sqlite3 version 3.43.0
    .define("SQLITE_DEFAULT_MEMSTATUS", to: "0"),
    .define("SQLITE_DISABLE_PAGECACHE_OVERFLOW_STATS"),
    .define("SQLITE_DQS", to: "0"),
    .define("SQLITE_ENABLE_API_ARMOR", .when(configuration: .debug)),
    .define("SQLITE_ENABLE_COLUMN_METADATA"),
    .define("SQLITE_ENABLE_DBSTAT_VTAB"),
    .define("SQLITE_ENABLE_FTS3"),
    .define("SQLITE_ENABLE_FTS3_PARENTHESIS"),
    .define("SQLITE_ENABLE_FTS3_TOKENIZER"),
    .define("SQLITE_ENABLE_FTS4"),
    .define("SQLITE_ENABLE_FTS5"),
    .define("SQLITE_ENABLE_NULL_TRIM"),
    .define("SQLITE_ENABLE_RTREE"),
    .define("SQLITE_ENABLE_SESSION"),
    .define("SQLITE_ENABLE_STMTVTAB"),
    .define("SQLITE_ENABLE_UNKNOWN_SQL_FUNCTION"),
    .define("SQLITE_ENABLE_UNLOCK_NOTIFY"),
    .define("SQLITE_MAX_VARIABLE_NUMBER", to: "250000"),
    .define("SQLITE_LIKE_DOESNT_MATCH_BLOBS"),
    .define("SQLITE_OMIT_AUTHORIZATION"),
    .define("SQLITE_OMIT_COMPLETE"),
    .define("SQLITE_OMIT_DEPRECATED"),
    .define("SQLITE_OMIT_DESERIALIZE"),
    .define("SQLITE_OMIT_GET_TABLE"),
    .define("SQLITE_OMIT_LOAD_EXTENSION"),
    .define("SQLITE_OMIT_PROGRESS_CALLBACK"),
    .define("SQLITE_OMIT_SHARED_CACHE"),
    .define("SQLITE_OMIT_TCL_VARIABLE"),
    .define("SQLITE_OMIT_TRACE"),
    .define("SQLITE_SECURE_DELETE"),
    .define("SQLITE_THREADSAFE", to: "1"),
    .define("SQLITE_UNTESTABLE"),
    .define("SQLITE_USE_URI")
] }
