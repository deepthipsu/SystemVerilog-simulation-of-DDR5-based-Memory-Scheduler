module memory_scheduler();

import declarations0::*;
import definitions0::*;
import declarations1::*;
import definitions1::*;

initial 
begin : initial_blk
	
test--;
$display("test value %b", test);

	// Fetch input and output file names from command line; else default the names along with debug status
	get_file_names(in_filename, out_filename, debug);

	// Open the files for read and write
	open_files(in_data);

// Read first entry from input trace file
	read_from_file(in_filename);
	
while (!done)
begin: while_done

// Check CPU clock and push queue
	if(in_data.cpu_cycles <= clock)	
	begin : time_check
		if(size_queue())
		begin: size_of_queue
			push_queue();
			read_from_file(in_filename);
		end : size_of_queue
	end : time_check

// Check for DIMM clock
	if(!(clock%2))
	begin : DIMM_Clk
// Read first in progress item
		//read_entry_to_process(); 
	//	if (next_command(queue_row[0]))
		//begin : next_command
	//		out_file_upd(queue_row[0], clock);
		//end : next_command
	end: DIMM_Clk

// Setting done bit at the end of simulation
if(queue_main.size() == 0 && $feof(in_file) && request_pending == 0)
begin : set_done
done = 1;
end : set_done

	clock++;
	//update_counters();

end: while_done
        
end : initial_blk
endmodule
