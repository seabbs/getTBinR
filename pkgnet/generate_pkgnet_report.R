library(pkgnet)

## Declare paths explicitly as currently required by pkgnet
pkg_path <- system.file(package = "getTBinR")
report_path <- file.path(getwd(), "getTBinR_report.html")

## Generate pkg report
## Not using coverage report as currently causes an error: 
## Error in bmerge(i, x, leftcols, rightcols, io, xo, roll, rollends, nomatch,  : 
## typeof x.node (double) != typeof i.node (character) 
report <- CreatePackageReport("getTBinR",
                              report_path = report_path)


