
package definitions1;

import declarations0::*;
import declarations1::*;


// reads the lines of the input file
function read_from_file(string in_filename);
	if (!$feof(in_file)) begin
            if ($fgets(line, in_file)) begin
                num_entries = $sscanf(line, "%d %d %d %h", in_data.cpu_cycles, in_data.core , in_data.operation, in_data.address);
                
            end
        end
endfunction

// check the size of queue
function size_of_queue();
	if (queue_main.size() < MAX_QUEUE_SIZE) begin
	  return 1;
	end
endfunction

// Pushing into queue

function push_queue();
     
endfunction

endpackage