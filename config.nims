
task testReposCreate, "Create a test-repos zipped cache":
  exec "nim c -r test-repos/createTestReposZip"

task testReposSetup, "Setup test-repos from a cached zip":
  exec "nim c -r test-repos/downloadTestRepos"
