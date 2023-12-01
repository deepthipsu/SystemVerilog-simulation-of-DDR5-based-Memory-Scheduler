package declarations0;

string in_filename, out_filename, line;
int in_file, out_file, num_entries;
bit[1:0] debug ;

// Input file format
typedef struct packed {
		bit [63:0] cpu_cycles;
		bit [3:0] core;
		bit [1:0] operation;
		bit [33:0] address;
		} input_data;

input_data in_data;


endpackage
