

package definitions0;

import declarations0::*;
import declarations1::*;

// Function to fetch input and output file names and debug status from command line; set to default if not available
function get_file_names(inout string in_filename, string out_filename, bit[1:0] debug);

	if (!$value$plusargs("debug=%d", debug)) 
	begin
            debug = 0;  // Default to no debug mode
        end

        if (!$value$plusargs("in_file=%s", in_filename)) 
	begin
            in_filename = "trace.txt";  // Default filename
        end

	if (!$value$plusargs("out_file=%s", out_filename)) 
	begin
            out_filename = "dram.txt";  // Default filename
        end
	return 1;
endfunction


// Opens both input and output files and reads first entry from input trace file
function open_files(inout  input_data in_data);

// Open input file for read
	in_file = $fopen(in_filename, "r");
        if (in_file == 0) 
	begin
            	$display("Error: Failed to open file %s", in_filename);
            	//$finish;
		return 0;
	end

// Open output file for write
	out_file=$fopen(out_filename,"w");
	if (out_file == 0) 
	begin
            	$display("Error: Failed to open file %s", out_filename);
            	//$finish;
		return 0;
	end

		return 1;

endfunction


// Function for address mapping
function void address_mapping (input bit [33:0]address, 
				output add_map mapped_add);

mapped_add = address;

if(debug == 5)
begin
	$display("address %h, mapped add %p", address, mapped_add);
end

endfunction


// Pop processed entries from queue
function void pop_queue();
if(queue_main[0].status == processed)
begin
	if (!(|queue_main[0].tp))
	begin
		queue_pop_entry = queue_main.pop_front();
		if(debug == 3)
		begin
			$display(" queue_main[0].tp = %p", &queue_main[0].tp);
			$display("clock - %d , Deleted entry from queue - %p", clock, queue_pop_entry);
		end
	end
end
endfunction


// Function to add entries to output file
function void out_file_upd(input queue_structure o, input bit [63:0] clock);

// out_file=$fopen("dram.txt","w");
$fwrite(out_file, " %d\t%d\t%p\t%p\t%p\t", clock, o.mapped_add.channel, o.curr_cmd, o.mapped_add.bank_group, o.mapped_add.bank);   
if(o.curr_cmd == PRE)
begin : none
$fwrite(out_file, " \n");
end : none
else if(o.curr_cmd == ACT0 || o.curr_cmd == ACT1)
begin : row
$fwrite(out_file, " %h\n", o.mapped_add.row);  
end : row
else
begin : col
$fwrite(out_file, " %h\n", {o.mapped_add.col_high, o.mapped_add.col_low});  
end : col

endfunction

function void close_files();

$fclose(out_file);
$fclose(in_file);

endfunction


function void inc_clk();

if(queue_main.size() == 0 && !$feof(in_file) && request_pending == 0)
	begin
		clock = clock + in_data.cpu_cycles;
	end
else
	begin
		clock++;
	end

endfunction

endpackage
