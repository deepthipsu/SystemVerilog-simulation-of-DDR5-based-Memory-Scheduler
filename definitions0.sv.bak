

package definitions0;

import declarations0::*;

// Function to fetch input and output file names and debug status from command line; set to default if not available
function automatic get_file_names(inout string in_filename, string out_filename, bit[1:0] debug);

	if (!$value$plusargs("debug=%d", debug)) begin
            debug = 0;  // Default to no debug mode
        end

        if (!$value$plusargs("in_file=%s", in_filename)) begin
            in_filename = "trace.txt";  // Default filename
        end

	if (!$value$plusargs("out_file=%s", out_filename)) begin
            out_filename = "dram.txt";  // Default filename
        end

endfunction


// Opens both input and output files and reads first entry from input trace file
function automatic get_first_entry(inout  input_data in_data);

	$display ("in_filename %d", in_filename); 
// Open input file for read
	in_file = $fopen(in_filename, "r");
        if (in_file == 0) begin
            $display("Error: Failed to open file %s", in_filename);
            //$finish;
        end

// Open output file for write
	out_file=$fopen(out_filename,"w");
	if (out_file == 0) begin
            $display("Error: Failed to open file %s", out_filename);
            //$finish;
        end
	$fgets(line, in_file);
	num_entries = $sscanf(line, "%d %d %d %h", in_data.cpu_cycles, in_data.core , in_data.operation, in_data.address);
	$display ("entries %p", in_data); 
	if(num_entries == 4)
		return 1;
	else
	begin
		$display("Error: mismatched input arguments in %s", in_filename);
            	$finish;
	end
endfunction

endpackage
