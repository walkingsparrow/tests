library(PivotalR)

PivotalR:::test()

PivotalR:::.testing.env

ls(PivotalR:::.testing.env)

auto_test(code_path = "~/workspace/rwrapper/PivotalR/R",
          test_path = "~/workspace/rwrapper/PivotalR/tests/",
          env = test_env())

PivotalR:::.testing.env

auto_test(code_path = "~/workspace/rwrapper/PivotalR/R",
          test_path = "~/workspace/rwrapper/PivotalR/tests/",
          env = PivotalR:::.testing.env)

ls(PivotalR:::.testing.env)

PivotalR:::.testing.env$port

.testing.env <- new.env()
.testing.env$.param <- list(a=2)

ls(.testing.env)

names(.testing.env$.param)

attach(.testing.env)
