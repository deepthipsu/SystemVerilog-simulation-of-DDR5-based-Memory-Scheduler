module memory_scheduler();

import declarations0::*;
import definitions0::*;

initial 
begin : initial_blk
	
	// Fetch input and output file names from command line; else default the names along with debug status
	get_file_names(in_filename, out_filename, debug);

	// Open the files for read and write
	open_files(in_data);

// Read first entry from input trace file
	read_from_file();
	
while (!done)
begin: while_done

	clock++;

// Check CPU clock and push queue
	if(in_data.cpu_cycles <= clock)	
	begin : time_check
		if(size_of_queue())
		begin: size_of_queue
			push_queue();
			read_from_file();
		end : size_of_queue
	end : time_check

// Check for DIMM clock
	if(!(clock%2))
	begin : DIMM_Clk
// Read first in progress item
		read_entry_to_process();

	end: DIMM_Clk

end: while_done
        
end : initial_blk
endmodule
