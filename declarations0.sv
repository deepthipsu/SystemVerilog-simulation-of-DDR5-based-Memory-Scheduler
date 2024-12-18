package declarations0;

string in_filename, out_filename, line;
int in_file, out_file, num_entries;
int debug ;

bit [1:0] test = 0;

// Input file format
typedef struct packed {
		bit [63:0] cpu_cycles;
		bit [3:0] core;
		bit [1:0] operation;
		bit [33:0] address;
		} input_data;

input_data in_data;


bit done = 0; // done bit
bit [63:0] clock = 0; // clock
bit request_pending = 0;

// Address Mapping
typedef struct packed {
		bit [15:0] row;
		bit [5:0] col_high;
		bit [1:0] bank;
		bit [2:0] bank_group;
		bit channel;
		bit [3:0] col_low;
		bit [1:0] byte_sel;
		} add_map;

// Timing Parameters
typedef struct packed {
		bit [7:0] tRC;
		bit [7:0] tRAS;
		bit [4:0] tRRD_L;
		bit [4:0] tRRD_S;
		bit [6:0] tRP;
		bit [7:0] tRFC;
		bit [6:0] tCWD;
		bit [6:0] tCL;
		bit [6:0] tRCD;
		bit [5:0] tWR;
		bit [5:0] tRTP;
		bit [4:0] tCCD_L;
		bit [4:0] tCCD_S;
		bit [6:0] tCCD_L_WR;
		bit [4:0] tCCD_S_WR;
		bit [4:0] tBURST;
		bit [5:0] tCCD_L_RTW;
		bit [5:0] tCCD_S_RTW;
		bit [7:0] tCCD_L_WTR;
		bit [6:0] tCCD_S_WTR;
		} timing_param;


// Enum declarations for commands
typedef enum bit [3:0] {NULL, ACT0, ACT1, RD0, RD1, WR0, WR1, PRE, REF, RBL, WBL, WR} commands;
typedef enum bit [1:0] {not_started, in_progress, processed, hold} state;
typedef enum bit [1:0] {d_read, write, i_read} oper;

// Queue structure for processing
typedef struct packed {
		bit [63:0] cpu_cycles;
		add_map mapped_add;	
		commands curr_cmd;
		commands open_cmd;
		state    status;
		oper operation;
		timing_param tp;
		} queue_structure;

queue_structure queue_main [$];
queue_structure request;
queue_structure queue_pop_entry;

endpackage
