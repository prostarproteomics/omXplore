# ##' @title hyperLOPIT PSM-level expression data
# ##'
# ##' @description
# ##'
# ##' A `data.frame` with PSM-level quantitation data by Christoforou *et al.*
# ##' (2016). This is the first replicate of a spatial proteomics dataset from a
# ##' hyperLOPIT experimental design on Mouse E14TG2a embryonic stem
# ##' cells. Normalised intensities for proteins for TMT 10-plex labelled
# ##' fractions are available for 3 replicates acquired in MS3 mode using an
# ##' Orbitrap Fusion mass-spectrometer.
# ##'
# ##' The variable names are
# ##'
# ##' - X126, X127C, X127N, X128C, X128N, X129C, X129N, X130C, X130N and
# ##'   X131: the 10 TMT tags used to quantify the peptides
# ##'   along the density gradient.
# ##'
# ##' - Sequence: the peptide sequence.
# ##'
# ##' - ProteinDescriptions: the description of the protein this peptide was
# ##'   associated to.
# ##'
# ##' - NbProteins: the number of proteins in the protein group.
# ##'
# ##' - ProteinGroupAccessions: the main protein accession number in the protein
# ##'   group.
# ##'
# ##' - Modifications: post-translational modifications identified in the peptide.
# ##'
# ##' - qValue: the PSM identification q-value.
# ##'
# ##' - PEP: the PSM posterior error probability.
# ##'
# ##' - IonScore: the Mascot ion identification score.
# ##'
# ##' - NbMissedCleavages: the number of missed cleavages in the peptide.
# ##'
# ##' - IsolationInterference: the calculated precursor ion isolation interference.
# ##'
# ##' - IonInjectTimems: the ions injection time in milli-seconds.
# ##'
# ##' - Intensity: the precursor ion intensity.
# ##'
# ##' - Charge: the peptide charge.
# ##'
# ##' - mzDa: the peptide mass to charge ratio, in Daltons.
# ##'
# ##' - MHDa: the peptide mass, in Daltons.
# ##'
# ##' - DeltaMassPPM: the difference in measure and calculated mass, in parts per
# ##'   millions.
# ##'
# ##' - RTmin: the peptide retention time, in minutes.
# ##'
# ##' - markers: localisation for well known sub-cellular markers. QFeatures of
# ##'   unknown location are encode as `"unknown"`.
# ##'
# ##' For further details, install the `pRolocdata` package and see
# ##' `?hyperLOPIT2015`.
# ##'
# ##' @source
# ##'
# ##' The `pRolocdata` package: \url{http://bioconductor.org/packages/pRolocdata/}
# ##'
# ##' @references
# ##'
# ##' *A draft map of the mouse pluripotent stem cell spatial proteome*
# ##' Christoforou A, Mulvey CM, Breckels LM, Geladaki A, Hurrell T, Hayward PC,
# ##' Naake T, Gatto L, Viner R, Martinez Arias A, Lilley KS. Nat Commun. 2016 Jan
# ##' 12;7:8992. doi: 10.1038/ncomms9992. PubMed PMID: 26754106; PubMed Central
# ##' PMCID: PMC4729960.
# ##'
# ##' @seealso
# ##'
# ##' See [QFeatures] to import this data using the [readQFeatures()] function.
# ##'
# ##' @md
# "hlpsms"


##' Feature example data
##'
##' `vdata` is a small object for testing and
##' demonstration.  `vdata_na`
##' is a tiny test set that contains missing values used to
##' demonstrate and test the impact of missing values on data
##' processing.
##'
##'
##' @source
##'
##' `vdata` was built from the source code available in
##' [`inst/scripts/build_datasets.R`](https://github.com/prostarproteomics/omXplore/blob/main/inst/scripts/build_datasets.R)
##' 
##' @aliases ft_na se_na2 feat2
##'
"vdata"


##' Feature example data
##'
##' `sub_R25_prot` is a protein subset of the dataset 'Exp1_R25_prot' in the 
##' package 'DAPARdata'. 
##'
##' @source
##'
##' `sub_R25_prot` was built from the source code available in
##' [`inst/scripts/build_datasets.R`](https://github.com/prostarproteomics/omXplore/blob/main/inst/scripts/build_datasets.R)
##'  
##' The `DAPARdata` package: \url{https://github.com/prostarproteomics/DAPARdata}
##'
##' @aliases sub_R25_pept
##'
##' @examples
##' 
##' data(sub_R25_prot)
##' view_dataset(sub_R25_prot)
##' 
"sub_R25_prot"

##' Feature example data
##'
##' `sub_R25_pept` is a protein subset of the dataset 'sub_R25_pept' in the 
##' package 'DAPARdata'. 
##'
##' @source
##'
##' `sub_R25_pept` was built from the source code available in
##' [`inst/scripts/build_datasets.R`](https://github.com/prostarproteomics/omXplore/blob/main/inst/scripts/build_datasets.R)
##'  
##' The `DAPARdata` package: \url{https://github.com/prostarproteomics/DAPARdata}
##'
##' @aliases sub_R25_prot
##' 
##' @examples
##' 
##' data(sub_R25_pept)
##' view_dataset(sub_R25_pept)
##' 
##'
"sub_R25_pept"