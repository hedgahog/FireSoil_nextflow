include { CAT_FASTQ } from './modules/nf-core/cat/fastq/main'
include { EMU_ABUNDANCE } from './modules/nf-core/emu/abundance/main'
include { NANOQ } from './modules/nf-core/nanoq/main' 

params.raw_data = "${projectDir}/raw_data"
params.outdir = 'results'


workflow {
    def barcode_reads = channel
        .fromPath("${params.raw_data}/*", type: 'dir', checkIfExists: true)
        .map { folder ->
            def reads = folder.toFile().listFiles()
                .findAll { file -> file.isFile() && file.name.endsWith('.fastq.gz') }
                .sort { file -> file.name }
                .collect { file -> file.toPath() }

            [[id: folder.name, single_end: true], reads]
        }
        .filter { _meta, reads -> reads.size() > 0 }

    CAT_FASTQ(barcode_reads)

    NANOQ(
        CAT_FASTQ.out.reads,
        params.nanoq_output_format
    )
    NANOQ.out.stats.view()
    NANOQ.out.reads.view()
}