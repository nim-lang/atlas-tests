import std/[os, strutils]

task runWsGenerated, "Run creation script for ws_generated":
  exec "nim c -r wsGenerated"

task runWsIntegration, "Run creation script for ws_integration":
  exec "nim c -r wsIntegration"

task atlasTestsCreate, "Create a atlas-tests zipped cache":
  exec "nim c -r createTestReposZip"

task atlasTestsSetup, "Setup atlas-tests from a cached zip":
  exec "nim c -r downloadTestRepos"

task cleanDist, "Clean all":
  rmDir("working")
  rmDir("ws_generated")
  rmDir("ws_integration")
  for item in walkDir("."):
    if item.kind == pcFile and item.path.endsWith(".zip"):
      rmFile(item.path)

task atlasTestsVersion, "Get version":
  let nimble = readFile("atlas_tests.nimble")
  var ver = ""
  for line in nimble.split("\n"):
    if line.startsWith("version ="):
      ver = line.replace("\"", "").split("=")[1].strip()
  doAssert ver != "" and " " notin ver and ver.len() < 10, "need to provide atlas version"
  echo ver
