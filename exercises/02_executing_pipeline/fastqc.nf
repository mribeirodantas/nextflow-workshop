#!/usr/bin/env nextflow

params.reads = "$launchDir/data/*.fq.gz" // $projectDir is another interesting implicit variable


/**
 * Quality control fastq
 */

reads_ch = Channel
    .fromPath( params.reads )
    .view()
    
process fastqc {
    container 'quay.io/biocontainers/fastqc:0.11.9--0'

    input:
    path read  
    
    script:
    """
    fastqc ${read}
    """
}

workflow {
    fastqc(reads_ch)
}