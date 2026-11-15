include { CAT_FASTQ } from './modules/nf-core/cat/fastq/main'
include { EMU_ABUNDANCE } from './modules/nf-core/emu/abundance/main'
include { NANOQ } from './modules/nf-core/nanoq/main' 

params.raw_data = "${projectDir}/raw_data"
params.outdir = '/results'

workflow {

    // 3. Build the input channel
    //    Goal shape, one item per sample:  [ [id:'barcode01', single_end:true], [file1, file2, ...] ]
    ch_reads = Channel.fromP

    ch_reads.view()   // check the shape BEFORE connecting any module

    // 4. Connect modules: each one's input = the previous one's .out.<emit name>
    // TODO: CAT_FASTQ( ... )
    // TODO: NANOQ( ... )
    // TODO: EMU_ABUNDANCE( ... )
}
