default: all


all: getTBinR_report.html

getTBinR_report.html:
		Rscript generate_pkgnet_report.R
		mv /usr/local/lib/R/site-library/pkgnet/package_report/getTBinR_report.html .