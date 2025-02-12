
task createWsGenerated, "Create a atlas-tests zipped cache":
  exec "nim c -r createTestReposZip"

task testReposCreate, "Create a atlas-tests zipped cache":
  exec "nim c -r createTestReposZip"

task testReposSetup, "Setup atlas-tests from a cached zip":
  exec "nim c -r downloadTestRepos"
