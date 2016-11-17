package com.azavea.loader

import org.apache.toree.dependencies.CoursierDependencyDownloader

import java.io.File

object Main {
  case class Params(val destDir: Option[File] = None,
                    val repos: Seq[String] = List("http://dl.bintray.com/azavea/geotrellis/",    
                                                  "http://maven.geo-solutions.it/",
                                                  "http://download.osgeo.org/webdav/geotools/"
                                                 )
                   )

  val parser = new scopt.OptionParser[Params]("geotrellis-jar-loader") {
    opt[String]('r', "repo")
      .text("Additional repository")
      .action( (x, conf) => {
        conf.copy(repos = x +: conf.repos)
      } )

    arg[File]("<directory>")
      .text("Name of the jars directory")
      .action( (x, conf) => conf.copy(destDir = Some(x)) )
  }

  object Version {
    val geotrellis = "1.0.0-720612f"
  }

  def main(args: Array[String]): Unit = {
    val params = parser.parse(args, Params()).get

    val cdd = new CoursierDependencyDownloader
    cdd.setDownloadDirectory(params.destDir.get)

    def grab(group: String, artifact: String, version: String) = 
      cdd.retrieve(group, artifact, version, true, true, true, params.repos.map{ s => (new java.net.URL(s), None) }, true, true)

    grab("com.azavea.geotrellis", "geotrellis-spark-etl_2.11", Version.geotrellis)
    grab("com.azavea.geotrellis", "geotrellis-slick_2.11", Version.geotrellis)
    grab("com.azavea.geotrellis", "geotrellis-geotools_2.11", Version.geotrellis)
    grab("com.azavea.geotrellis", "geotrellis-shapefile_2.11", Version.geotrellis)
  }
}
