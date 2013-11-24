/*cd `1'*/
insheet using `1'
mlogit `2', vce(robust)
estimate store model
estout model using `3', cells("b se t p")
