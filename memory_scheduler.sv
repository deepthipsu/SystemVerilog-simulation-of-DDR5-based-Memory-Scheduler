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

	// Check for DIMM clock 
	if(!(clock%2) && queue_main.size() > 0)
	begin : DIMM_Clk
			// Read first in progress item
			// read_entry_to_process(); 
		// Process the item
		if(queue_main[0].status == hold)begin
			open_command(queue_main[0]); end
		else
		begin : normal_process
				open_command(queue_main[0]);
				if (next_command(queue_main[0]))
				begin : next_command1
					out_file_upd(queue_main[0], clock);
				end : next_command1
		end : normal_process
	end: DIMM_Clk 



	// Update timing parameters and Empty queue if there are any entries in queue
	if (queue_main.size() > 0)
	begin
		update_counters();  	// Decrement timing parameter values
		pop_queue();		// Delete processed items from queue
	end



	// Check CPU clock and push queue
	if(in_data.cpu_cycles <= clock)	
	begin : time_check
		if(size_queue())
		begin: size_of_queue
			push_queue();
			if ( !read_from_file(in_filename))
			begin
				$display("Errors reading input file");
				$finish;
			end
		end : size_of_queue
	end : time_check



	// Setting done bit at the end of simulation	
	if(queue_main.size() == 0 && $feof(in_file) && request_pending == 0)
	begin : set_done
		close_files();
		done = 1;
		continue;
	end : set_done


	
	// Increment clock for next cycle
	inc_clk();

end: while_done
        
$display("End of simulation of %s", in_filename);

end : initial_blk
endmodule
