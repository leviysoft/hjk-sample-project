let Prelude =
      https://prelude.dhall-lang.org/v23.0.0/package.dhall sha256:397ef8d5cf55e576eab4359898f61a4e50058982aaace86268c62418d3027871

let Dependency = https://leviysoft.github.io/hjk/blueprints/0.1/Dependency.dhall sha256:1157150a4e8c411465890f79852fb1301f416ce63bc742f5caadb703c7346cc9

let formatDep = https://leviysoft.github.io/hjk/blueprints/0.1/formatDep.dhall sha256:83dbe21b2d3b11a7f84859a301bbcb7c151a911dad260c4dbeb48e3867687803

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
