let Prelude =
      https://prelude.dhall-lang.org/v23.0.0/package.dhall sha256:397ef8d5cf55e576eab4359898f61a4e50058982aaace86268c62418d3027871

let Tasks = https://leviysoft.github.io/hjk/blueprints/0.1/Task.dhall sha256:7b1e9b980a4cab28da1b4f649a3dbdaa7d28faef0638cc9d9aaa413a3e378b93

let Build = https://leviysoft.github.io/hjk/blueprints/0.1/Build.dhall sha256:18180b84956f42bda2131f26ee4e0a1759296175c57a6d9e3066e9a43aea57c9

let values = ./values.dhall sha256:6b4f82ca6388c751fe1d8430d4fdd21f161c7e7947a3fadb6a39229f06425135

let resolve =
      Tasks.Task.Simple
        Tasks.SimpleTask::{
        , name = "resolve"
        , cmd =
            \(_ : List Text) ->
              "cs fetch --classpath --scala ${values.scala.version} ${values.depString}"
        }

let compile =
      Tasks.Task.Dependent
        Tasks.DependentTask::{
        , name = "compile"
        , globs = [ "src/main/scala/**/*.scala" ]
        , dependsOn = "resolve"
        , cmd =
            \(sources : List Text) ->
            \(classpath : List Text) ->
              let classpathStr = Prelude.Text.concatSep ":" classpath

              let sourcesStr = Prelude.Text.concatSep "," sources

              in  "cs launch scalac:${values.scala.version} -- -classpath ${classpathStr} -d target ${sourcesStr}"
        }

let jar =
      Tasks.Task.Dependent
        Tasks.DependentTask::{
        , name = "jar"
        , globs = [ "src/main/scala/**/*.scala" ]
        , dependsOn = "resolve"
        , cmd =
            \(sources : List Text) ->
            \(classpath : List Text) ->
              let classpathStr = Prelude.Text.concatSep ":" classpath

              let sourcesStr = Prelude.Text.concatSep "," sources

              in  "cs launch scalac:${values.scala.version} -- -classpath ${classpathStr} -d target/example.jar ${sourcesStr}"
        }

let build
    : Build
    = { tasks = [ resolve, compile, jar ] }

in  build
