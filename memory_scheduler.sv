module memory_scheduler();

import declarations0::*;
import definitions0::*;

initial 
begin : initial_blk
	
	// Fetch input and output file names from command line; else default the names along with debug status
	get_file_names(in_filename, out_filename, debug);

	// Open the file and look for first entry in input file
	get_first_entry(in_data);
	
        
end : initial_blk
endmodule