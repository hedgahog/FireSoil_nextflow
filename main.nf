include { CAT_FASTQ } from './modules/nf-core/cat/fastq/main'
include { EMU_ABUNDANCE } from './modules/nf-core/emu/abundance/main'
include { NANOQ } from './modules/nf-core/nanoq/main' 


workflow {

    // 3. Build the input channel
    //    Goal shape, one item per sample:  [ [id:'barcode01', single_end:true], [file1, file2, ...] ]
    ch_reads = channel
    .fromPath("${params.input}/*/*.fastq.gz") // get all fastq.gz files in subfolders of raw_data
    .map { f ->
        def barcode = f.parent.name // name of the subfolder, e.g. "barcode01"
        tuple(barcode, f) 
        }
    .groupTuple() //group by barcode, so we have one item per sample i.e ('barcode05', [file1, file2, file3, ...])
    .map { barcode, f ->
        tuple( 
            [id:barcode, single_end:true], // metadata for the sample
            f.toList() // convert ArrayBag tolist of fastq files for the sample
        )   
        }


    ch_reads.view()   // check the shape BEFORE connecting any module

    // 4. Connect modules: each one's input = the previous one's .out.<emit name>
    CAT_FASTQ(ch_reads)
    NANOQ(
        CAT_FASTQ.out.reads, // input from the previous module
        params.nanoq_output_format, // input from the config file
    )
    EMU_ABUNDANCE(
        NANOQ.out.reads,
        file(params.emu_db, checkIfExists: true) // db input from the config file
)
    
}
