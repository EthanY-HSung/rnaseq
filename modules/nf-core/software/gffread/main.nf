// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
def options    = initOptions(params.options)

process GFFREAD {
    tag "$gff"
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:'') }

    container "quay.io/biocontainers/gffread:0.12.1--h8b12597_0"
    //container https://depot.galaxyproject.org/singularity/gffread:0.12.1--h8b12597_0

    conda (params.conda ? "bioconda::gffread=0.12.1" : null)

    input:
    path gff
    
    output:
    path "*.gtf"        , emit: gtf
    path "*.version.txt", emit: version

    script:
    def software = getSoftwareName(task.process)
    """
    gffread $gff $options.args -o ${gff.baseName}.gtf
    echo \$(gffread --version 2>&1) > ${software}.version.txt
    """
}
