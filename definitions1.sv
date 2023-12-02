
package definitions1;

import declarations0::*;
import declarations1::*;
import definitions0::*;


// reads the lines of the input file
function read_from_file(string in_filename);
	if (!$feof(in_file)) begin
            if ($fgets(line, in_file)) begin
                num_entries = $sscanf(line, "%d %d %d %h", in_data.cpu_cycles, in_data.core , in_data.operation, in_data.address);
		if (num_entries == 4) begin // Check if all items were successfully parsed
                    request_pending=1; 
		     return 1;
		   end else begin
		   $display("Error: mismatched input arguments in %s", in_filename);
            	    $finish;
		   end  
		  
                end                
            end
endfunction

// check the size of queue
function size_queue();
	if (queue_main.size() < MAX_QUEUE_SIZE && request_pending == 1) begin
	  return 1;
	end else begin 
	 $display("Queue is full. Cannot enqueue new requestuest.");
	end
endfunction

// Pushing into queue

function push_queue();
	address_mapping(in_data.address, request.mapped_add); 
	request.cpu_cycles = in_data.operation;
	request.operation = in_data.operation;
	 queue_main.push_back(request);
	request_pending =0;
            $display("[%0d] Pushed request: Core %0p", clock, request);
            if (debug) begin
                print_queue_contents(); // Print queue contents after insertion
            end         
endfunction

// display contents of queue
 function print_queue_contents();
int i;
        $display("Printing Queue Contents at simulation time %0d", clock);
        foreach (queue_main[i]) begin
            $display("Queue Element %0d: Time: %0d", 
                     i, queue_main[i].cpu_cycles);  
                   
        end
endfunction

// Task to get next command
function next_command (inout queue_structure queue_line);
  unique case(curr_cmd)
	ACT0: begin 
	       curr_cmd = ACT1; row_col = 0;
	      end
	ACT1: begin 
		curr_cmd = (operation == 1)? WR0 : RD0; row_col = 1; 
		
		end



	RD0: begin curr_cmd = RD1; row_col = 1; end
	RD1: begin curr_cmd = PRE; row_col = 'x; end
	WR0: begin curr_cmd = WR1; row_col = 1; end
	WR1: begin curr_cmd = PRE; row_col = 'x; end
	PRE: begin curr_cmd = ACT0; row_col = 0; end
	REF: begin curr_cmd = PRE; row_col = 'x; end
default : begin curr_cmd = ACT0;status = in_progress;row_col = 0; end
endcase

endfunction


endpackage