
import std / [os, strutils, strformat]
import downloadTestRepos

proc buildGraph* =
  createDir "buildGraph"
  withDir "buildGraph":

    createDir "proj_a"
    withDir "proj_a":
      exec "git init"

      writeFile "proj_a.nimble", "requires \"proj_b >= 1.0.0\"\n"
      exec "git add proj_a.nimble"
      exec "git commit -m 'initial commit; bump v1.0.0'"
      exec "git tag v1.0.0"

      writeFile "proj_a.nim", "echo \"hello world\"\n"
      exec "git add proj_a.nim"
      exec "git commit -m 'add nim file'"

      writeFile "proj_a.nimble", "requires \"proj_b >= 1.0.0\"\n# comment\n"
      exec "git add proj_a.nimble"
      exec "git commit -m 'update nimble comment'"

      writeFile "proj_a.nimble", "requires \"proj_b >= 1.1.0\"\n"
      exec "git add proj_a.nimble"
      exec "git commit -m 'update nimble requires; bump v1.1.0'"
      exec "git tag v1.1.0"

    createDir "proj_b"
    withDir "proj_b":
      exec "git init"

      writeFile "proj_b.nim", "echo \"hello world\"\n"
      exec "git add proj_b.nim"
      exec "git commit -m 'add nim file'"

      writeFile "proj_b.nimble", "requires \"proj_c >= 1.0.0\"\n"
      exec "git add proj_b.nimble"
      exec "git commit -m 'initial commit; bump v1.0.0'"
      exec "git tag v1.0.0"

      writeFile "proj_b.nimble", "requires \"proj_c >= 1.0.0\"\n# comment\n"
      exec "git add proj_b.nimble"
      exec "git commit -m 'update nimble comment'"

      writeFile "proj_b.nimble", "requires \"proj_c >= 1.1.0\"\n"
      exec "git add proj_b.nimble"
      exec "git commit -m 'update nimble requires; bump v1.1.0'"
      exec "git tag v1.1.0"

    createDir "proj_c"
    withDir "proj_c":
      exec "git init"

      writeFile "proj_c.nimble", "requires \"proj_d >= 1.2.0\"\n"
      exec "git add proj_c.nimble"
      exec "git commit -m 'initial commit'"

      writeFile "proj_c.nimble", "requires \"proj_d >= 1.0.0\"\n"
      exec "git commit -am 'update nimble requires; bump v1.2.0'"
      exec "git tag v1.2.0"

    createDir "proj_d"
    withDir "proj_d":
      exec "git init"

      writeFile "proj_d.nimble", "\n"
      exec "git add proj_d.nimble"
      exec "git commit -m 'Initial commit for project D; bump v1.0.0'"
      exec "git tag v1.0.0"

      writeFile "proj_d.nimble", "requires \"does_not_exist >= 1.2.0\"\n"
      exec "git add proj_d.nimble"
      exec "git commit -m 'broken version of package D; bump v2.0.0'"
      exec "git tag v2.0.0"

proc buildGraphNoGitTags* =
  createDir "buildGraphNoGitTags"
  withDir "buildGraphNoGitTags":

    createDir "proj_a"
    withDir "proj_a":
      exec "git init"

      writeFile "proj_a.nimble", "version = \"1.0.0\"\n\nrequires \"proj_b >= 1.0.0\"\n"
      exec "git add proj_a.nimble"
      exec "git commit -m 'initial commit; bump v1.0.0'"

      writeFile "proj_a.nimble", "version = \"1.0.0\"\n\nrequires \"proj_b >= 1.0.0\"\n# comments\n"
      exec "git add proj_a.nimble"
      exec "git commit -m 'update nimble comment'"

      writeFile "proj_a.nim", "echo \"hello world\"\n"
      exec "git add proj_a.nim"
      exec "git commit -m 'add nim file'"

      writeFile "proj_a.nimble", "version = \"1.1.0\"\n\nrequires \"proj_b >= 1.1.0\"\n"
      exec "git add proj_a.nimble"
      exec "git commit -m 'update nimble requires; bump v1.1.0'"

    createDir "proj_b"
    withDir "proj_b":
      exec "git init"

      writeFile "proj_b.nim", "echo \"hello world\"\n"
      exec "git add proj_b.nim"
      exec "git commit -m 'add nim file'"

      writeFile "proj_b.nimble", "version = \"1.0.0\"\n\nrequires \"proj_c >= 1.0.0\"\n"
      exec "git add proj_b.nimble"
      exec "git commit -m 'initial commit; bump v1.0.0'"

      writeFile "proj_b.nimble", "version = \"1.0.0\"\n\nrequires \"proj_c >= 1.0.0\"\n# comment\n"
      exec "git add proj_b.nimble"
      exec "git commit -m 'update nimble comment'"

      writeFile "proj_b.nimble", "version = \"1.1.0\"\n\nrequires \"proj_c >= 1.1.0\"\n"
      exec "git add proj_b.nimble"
      exec "git commit -m 'update nimble requires; bump v1.1.0'"

    createDir "proj_c"
    withDir "proj_c":
      exec "git init"

      writeFile "proj_c.nimble", "version = \"1.0.0\"\n\nrequires \"proj_d >= 1.2.0\"\n"
      exec "git add proj_c.nimble"
      exec "git commit -m 'initial commit; bump v1.0.0'"

      writeFile "proj_c.nimble", "version = \"1.2.0\"\n\nrequires \"proj_d >= 1.0.0\"\n"
      exec "git commit -am 'update nimble requires; bump v1.2.0'"

    createDir "proj_d"
    withDir "proj_d":
      exec "git init"

      writeFile "proj_d.nimble", "version = \"1.0.0\"\n\n"
      exec "git add proj_d.nimble"
      exec "git commit -m 'initial commit; bump v1.0.0'"

      writeFile "proj_d.nimble", "version = \"2.0.0\"\n\nrequires \"does_not_exist >= 1.2.0\"\n"
      exec "git add proj_d.nimble"
      exec "git commit -m 'broken version of package D; bump v2.0.0'"

proc runWsGenerated*() =
  withDir("atlas-tests"):
    removeDir("working")
    createDir "working"
    withDir("working"):
      buildGraph()
      buildGraphNoGitTags()

    var repos: seq[tuple[org: string, name: string]]
    template findRepo(item) =
      if item.kind == pcDir:
        # echo "GIT REPO: ", item
        let paths = item.path.split(DirSep)
        let repo = (org: paths[1], name: paths[2])
        # echo "GIT REPO: ", repo
        repos.add(repo)

    for item in walkDir("working"/"buildGraph"):
      findRepo(item)
    for item in walkDir("working"/"buildGraphNoGitTags"):
      findRepo(item)

    echo "Setup bare gits"
    removeDir("ws_generated")
    createDir("ws_generated")
    withDir("ws_generated"):
      writeFile("readme.md", "This directory holds the bare git modules used for testing.")
      for repo in repos:
        createDir(repo.org)
      for repo in repos:
        echo "REPO: ", repo
        withDir(repo.org):
          let orig = ".." / ".." / "working" / repo.org / repo.name
          echo "CLONING: ", " cwd: ", getCurrentDir()
          exec &"git clone --mirror {orig}"
          withDir(repo.name & ".git"):
            moveFile "hooks"/"post-update.sample", "hooks"/"post-update"
            setFilePermissions("hooks"/"post-update", getFilePermissions("hooks"/"post-update") + {fpUserExec})
            exec "git update-server-info"
            exec &"echo {repo.org}/{repo.name}.git `git rev-parse HEAD` >> ../../ws_generated-manifest.txt"
            exec &"echo ============================================== >> ../../ws_generated-logs.txt"
            exec &"echo {repo.org}/{repo.name}.git >> ../../ws_generated-logs.txt"
            exec &"echo ============================================== '\\n' >> ../../ws_generated-logs.txt"
            exec &"git log >> ../../ws_generated-logs.txt"
            exec "echo '\\n\\n' >> ../../ws_generated-logs.txt"

when isMainModule:
  runWsGenerated()
