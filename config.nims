
task runWsGenerated, "Run creation script for ws_generated":
  exec "nim c -r wsGenerated"

task runWsIntegration, "Run creation script for ws_integration":
  exec "nim c -r wsIntegration"

task testReposCreate, "Create a atlas-tests zipped cache":
  exec "nim c -r createTestReposZip"

task testReposSetup, "Setup atlas-tests from a cached zip":
  exec "nim c -r downloadTestRepos"
