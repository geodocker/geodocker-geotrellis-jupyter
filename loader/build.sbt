name := "geotrellis-jar-loader"
version := "0.1.0"
scalaVersion := Version.scala
organization := "com.azavea"
licenses := Seq("Apache-2.0" -> url("http://www.apache.org/licenses/LICENSE-2.0.html"))
scalacOptions ++= Seq(
  "-deprecation",
  "-unchecked",
  "-Yinline-warnings",
  "-language:implicitConversions",
  "-language:reflectiveCalls",
  "-language:higherKinds",
  "-language:postfixOps",
  "-language:existentials",
  "-feature")
publishMavenStyle := true
publishArtifact in Test := false
pomIncludeRepository := { _ => false }

resolvers += Resolver.bintrayRepo("azavea", "geotrellis")

libraryDependencies ++= Seq(
  "org.apache.toree.kernel" %% "toree-kernel-api" % "0.0.0-dev-SNAPSHOT",
  "com.github.scopt"     %% "scopt"          % "3.5.0"
)
