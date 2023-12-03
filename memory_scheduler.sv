module memory_scheduler();

import declarations0::*;
import definitions0::*;
import declarations1::*;
import definitions1::*;

initial 
begin : initial_blk
	



// Fetch input and output file names from command line; else default the names along with debug status
	if (get_file_names(in_filename, out_filename, debug))
	begin : get_file_names1
// Open the files for read and write
		if (open_files(in_data))
		begin : open_files1
// Read first entry from input trace file
			if ( !read_from_file(in_filename))
			begin
				$display("Errors reading input file");
				$finish;
			end
		end : open_files1
		else
		begin : check_open
			$display("Errors opening files");
			$finish;
		end : check_open
	end : get_file_names1


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
			// read_entry_to_process(); 
		// Process the item
		if(queue_main[0].status == hold)begin
			open_command(queue_main[0]); end
		else
		begin : normal_process
			//if (queue_main[0].open_cmd == NULL)
			//begin : proceed_next_cmd
				open_command(queue_main[0]);
				if (next_command(queue_main[0]))
				begin : next_command1
					out_file_upd(queue_main[0], clock);
				end : next_command1
			//end : proceed_next_cmd
			//else
			//begin : open_cmd
			//	open_command(queue_main[0]);
			//end : open_cmd
		end : normal_process
	end: DIMM_Clk 

	// check and delete finished items from queue
	//if (queue_main[0].status == finished)
		pop_queue();

	// Setting done bit at the end of simulation	
	if(queue_main.size() == 0 && $feof(in_file) && request_pending == 0)
	begin : set_done
		close_files();
		done = 1;
		continue;
	end : set_done

	// Increment clock and decrement timing parameter values
	update_counters();

end: while_done
        
$display("End of simulation of %s.txt", in_filename);

end : initial_blk
endmodule
