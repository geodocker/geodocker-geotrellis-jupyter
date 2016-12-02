import sbtassembly.PathList

// val generalDeps = Seq("org.apache.hadoop" % "hadoop-client" % "2.6.2")

lazy val commonSettings = Seq(
  organization := "org.locationtech.geotrellis",
  version := Version.geotrellis,
  scalaVersion := "2.11.8",
  test in assembly := {},
  assemblyMergeStrategy in assembly := {
    case "log4j.properties" => MergeStrategy.first
    case "reference.conf" => MergeStrategy.concat
    case "application.conf" => MergeStrategy.concat
    case PathList("META-INF", xs @ _*) =>
      xs match {
        case ("MANIFEST.MF" :: Nil) => MergeStrategy.discard
          // Concatenate everything in the services directory to keep GeoTools happy.
        case ("services" :: _ :: Nil) =>
          MergeStrategy.concat
          // Concatenate these to keep JAI happy.
        case ("javax.media.jai.registryFile.jai" :: Nil) | ("registryFile.jai" :: Nil) | ("registryFile.jaiext" :: Nil) =>
          MergeStrategy.concat
        case (name :: Nil) => {
          // Must exclude META-INF/*.([RD]SA|SF) to avoid "Invalid signature file digest for Manifest main attributes" exception.
          if (name.endsWith(".RSA") || name.endsWith(".DSA") || name.endsWith(".SF"))
            MergeStrategy.discard
          else
            MergeStrategy.first
        }
        case _ => MergeStrategy.first
      }
    case _ => MergeStrategy.first
  },
  shellPrompt := { s => Project.extract(s).currentProject.id + " > " },
  resolvers += "LocationTech GeoTrellis Releases" at "https://repo.locationtech.org/content/repositories/geotrellis-releases",
  libraryDependencies ++= Seq(
    "org.locationtech.geotrellis" %% "geotrellis-accumulo" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-cassandra" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-geotools" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-hbase" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-proj4" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-raster" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-s3" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-shapefile" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-slick" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-spark-etl" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-spark" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-util" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-vectortile" % Version.geotrellis,
    "org.locationtech.geotrellis" %% "geotrellis-vector" % Version.geotrellis,
    "org.apache.hadoop" % "hadoop-client" % Version.hadoop % "provided",
    "org.apache.spark" %% "spark-core" % Version.spark % "provided"
  )
)

lazy val uberjar = Project("geotrellis-uberjar", file("."))
  .settings(commonSettings: _*)
