let Prelude =
      https://prelude.dhall-lang.org/v23.0.0/package.dhall
        sha256:397ef8d5cf55e576eab4359898f61a4e50058982aaace86268c62418d3027871

let Dependency = ./.blueprints/Dependency.dhall

let formatDep = ./.blueprints/formatDep.dhall

let scala = { version = "2.13.15", suffix = "_2.13" }

let dependencies
    : List Dependency.Type
    = [ { group = "org.typelevel"
        , module = "cats-core"
        , version = "2.12.0"
        , cross = True
        }
      ]

let depList
    : List Text
    = Prelude.List.map Dependency.Type Text formatDep dependencies

let depString
    : Text
    = Prelude.Text.concatSep ";" depList

in  { scala, dependencies, depString }
