---
layout: post
title: "removing crufy image layers"
date: 2018-04-09
preview: sometimes docker image layers build up during development. How do I remove them?
---

Sometimes Docker image layers build up during development and it's important to remove them. I usually include the following `make` task in projects to automate the cleanup:

    clean: ## removes temporary artifacts and image build layers
        @rm -rf /tmp/*
        @docker image | awk '/<none>/{ print $3 }' | xargs docker rmi

The command `docker images` lists all image layers on the system...

    $ docker images
      REPOSITORY                                          TAG                 IMAGE ID            CREATED             SIZE
      jprime/cool-project                                 ruby                517b3ddd3ed9        5 hours ago         997MB
      <none>                                              <none>              55c21bc89426        5 hours ago         998MB

I pipe this output to `awk`, matching lines that contain `<none>` and printing the third datum, the image id...

    $ docker images | awk '/<none>/{ print $3 }'
      55c21bc89426

Finally I pipe those image ids to `xargs`, removing each image layer with `docker rmi`...

    $ docker images | awk '/<none>/{ print $3 }' | xargs docker rmi
      Deleted: sha256:55c21bc89426b5048c2eb75bc6b73edf8ad28a432cea88e6ac0f68734000cac3
      Deleted: sha256:5af4d4ab8ecab859f10e05958f3007b68093214af31ef660dba6abe17eab1f75
      Deleted: sha256:d44a2cb5d859814c87ea18f912f29b200df33b6e0ec3bc9a965106234f4ec097
      Deleted: sha256:3b60d89fa81a25b77818d56de4265cb5cb019ab3fc20f6d97649afda27afcdf0
      Deleted: sha256:affe28542a29ed2ebb74ee9ea06762d31a6aa9aa4d1d7a00b606eb157e3496f4

This clears quite a bit of space on the filesystem, and the command is safe because docker will not remove a layer that's in use by a running or stopped container. I use this often enough that I wrap it in the `make` task described above.