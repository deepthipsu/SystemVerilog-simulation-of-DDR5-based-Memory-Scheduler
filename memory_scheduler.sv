module memory_scheduler();

import declarations0::*;
import definitions0::*;

initial 
begin : initial_blk
	
	// Fetch input and output file names from command line; else default the names along with debug status
	get_file_names(in_filename, out_filename, debug);

	// Open the file and look for first entry in input file
	get_first_entry(in_data);
	
while (!done)
begin: while_done

	clock++;

// Check CPU clock and push queue
	if(req_time_check())	
		push_queue();

// Check for DIMM clock
	if(!(clock%2))
	begin : DIMM_Clk
// Read first in progress item
		read_entry_to_process();

	end: DIMM_Clk

end: while_done
        
end : initial_blk
endmodule
