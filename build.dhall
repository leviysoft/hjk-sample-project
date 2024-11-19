let Prelude =
      https://prelude.dhall-lang.org/v23.0.0/package.dhall
        sha256:397ef8d5cf55e576eab4359898f61a4e50058982aaace86268c62418d3027871

let Tasks = ./.blueprints/Task.dhall

let Build = ./.blueprints/Build.dhall

let values = ./values.dhall

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
