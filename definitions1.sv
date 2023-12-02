
package definitions1;

import declarations0::*;
import declarations1::*;
import definitions0::*;


// reads the lines of the input file
function read_from_file(string in_filename);
	if (!$feof(in_file)) begin
            if ($fgets(line, in_file)) begin
                num_entries = $sscanf(line, "%d %d %d %h", in_data.cpu_cycles, in_data.core , in_data.operation, in_data.address);
                
            end
        end
endfunction

// check the size of queue
function size_queue();
	if (queue_main.size() < MAX_QUEUE_SIZE) begin
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
            $display("[%0d] Pushed requestuest: Core %0p", clock, request);
            if (debug) begin
                print_queue_contents(); // Print queue contents after insertion
            end         
endfunction

// display contents of queue
 function print_queue_contents();
int i;
        $display("Printing Queue Contents at simulation time %0d", clock);
        foreach (queue_main[i]) begin
            $display("Queue Element %0d: Time: %0d, byte_sel: %0d, Address: %h", 
                     i, queue_main[i].cpu_cycles); //queue_main[i].byte_sel, 
                     //queue_main[i].address);
        end
endfunction

endpackage