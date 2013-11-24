setMethod (
    "-",
    signature(e1 = "db.obj", e2 = "numeric"),
    function (e1, e2) {
        .compare(e1, e2, " - ", .num.types, res.type = "double precision",
                 res.udt = "float8")
    },
    valueClass = "db.Rquery")
