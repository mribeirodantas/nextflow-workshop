#!/usr/bin/env nextflow


// Similar to DSL1, the input data is defined in the beginning.
params.reads = "${launchDir}/data/*{1,2}.fq.gz"
params.outdir = "${launchDir}/results"

log.info """\
      LIST OF PARAMETERS
================================
Reads            : ${params.reads}
Output-folder    : ${params.outdir}/
"""

// Also channels are being created. 
read_pairs_ch = Channel
      .fromFilePairs(params.reads, checkIfExists:true)
      
// Definition of a process
// A process being defined, does not mean it's invoked (see workflow)
process fastqc {
  publishDir "${params.outdir}/quality-control-${sample}/", mode: 'copy', overwrite: true
  container 'quay.io/biocontainers/fastqc:0.11.9--0'
  
  input:
  tuple val(sample), path(reads)  // from is omitted

  output:
  path("*_fastqc.{zip,html}") 

  script:
  """
  fastqc ${reads}
  """
}

// Running a workflow with the defined processes here.  
workflow {
	read_pairs_ch.view()
	fastqc(read_pairs_ch) 
}
