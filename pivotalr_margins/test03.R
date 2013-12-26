setClass("test", representation(val = "numeric"))

setMethod("-",
          signature(e1="test", e2="test"),
          function(e1, e2) {
              if (nargs() == 1) -12
              else 24
          })

setMethod("-",
          signature(e1="test", e2="ANY"),
          function(e1, e2) {
              if (nargs() == 1) -12
              else 25
          })

x <- new("test", val=23)

-x

x-x
