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
	 $display("Cannot enqueue new request. Queue_size=%0d, request_pending=%0d",queue_main.size(),request_pending);
		return 0;
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
            $display("Queue Element %0d: Time: %0p",i, queue_main[i]);               
        end
endfunction

//Function for open command 
function open_command(inout queue_structure queue_line);
  unique case(queue_line.open_cmd)
	RD1: begin
		if(tCL==0) begin
		queue_line.open_cmd=RBL;
		queue_line.tp.tBURST=tBURST; 
		end
	     end
	RBL: begin 
		if(queue_line.tp.tBurst==0) begin
		 queue_line.status = in_progress;
		end
	      end	
	WBL: begin 
		if(queue_line.tp.tBurst==0) begin
		  queue_line.status = in_progress;
		  queue_line.tp.tWR=tWR;
		  queue_line.open_cmd=WR;
		end
	      end 
     endcase
endfunction


// Function to get next command
function next_command (inout queue_structure queue_line); 
  unique case(queue_line.curr_cmd)
	ACT0: begin 
	        queue_line.curr_cmd = ACT1; 
		 queue_line.tp.tRC=tRC;
		 queue_line.tp.tRAS=tRAS;
		 queue_line.tp.tRRD_L=tRRD_L;
		 queue_line.tp.tRRD_S=tRRD_S;
		 queue_line.tp.tRCD=tRCD;
	      end
	ACT1: begin 
		if(queue_line.tp.tRCD==0) begin
		  queue_line.curr_cmd = (queue_line.operation == 1)? WR0 : RD0;
		end
	      end
	RD0: begin 
		//if(tRAS==0 && tCL==0 && tRTP==0) begin
		  queue_line.curr_cmd = RD1; 
		queue_line.tp.tCL=tCL;
		queue_line.tp.tRTP=tRTP;
		queue_line.tp.tCCD_L=tCCD_L;
		queue_line.tp.tCCD_S=tCCD_S;
		queue_line.tp.tCCD_L_RTW=tCCD_L_RTW;
		queue_line.tp.tCCD_S_RTW=tCCD_S_RTW; 
	
	RD1: begin 
		if(queue_line.tp.tRTP==0) begin
		 queue_line.curr_cmd = PRE; 
		 queue_line.tp.tRP=tRP;
		end	
	     end
	WR0: begin 
		queue_line.curr_cmd = WR1; 
		queue_line.tp.tCWD=tCWD;
		queue_line.tp.tCCD_L_WR=tCCD_L_WR;
		queue_line.tp.tCCD_S_WR=tCCD_S_WR;
		queue_line.tp.tCCD_L_WTR=tCCD_L_WTR;
		queue_line.tp.tCCD_S_WTR=tCCD_S_WTR;
	     end
	WR1: begin
		if(queue_line.tp.tCWD==0) begin
			queue_line.open_cmd = WBL; 
			queue_line.tp.tBURST=tBURST;
			queue_line.status = hold; 
		end
		end
	PRE: begin 
		/*if(tRAS==0 && tWR==0 && tRTP==0) begin
			//queue_line.curr_cmd = ACT0; 
		 	//queue_line.tp.tRP=tRP;
		  end*/
		if(queue_line.tp.tRP==0) begin 
		  queue_line.status = finished;
			//pop_queue();
		end
		end
	      
	REF: begin 
		if(queue_line.tp.tRFC==0)
			queue_line.curr_cmd = PRE; 
		end
		end
	default: begin
			if(queue_line.tp.tRC==0 && queue_line.tp.tRP==0) begin
	 		   queue_line.curr_cmd = ACT0;
			   queue_line.status = in_progress;
	 		end
		   end
    endcase
endfunction

// Function for update counter 
function update_counters();
  clock++;
	queue_main[0].tp.tRC = (queue_main[0].tp.tRC == 0)?  queue_main[0].tp.tRC: queue_main[0].tp.tRC--;
	queue_main[0].tp.tRAS = (queue_main[0].tp.tRAS == 0)? queue_main[0].tp.tRAS : queue_main[0].tp.tRAS--;
	queue_main[0].tp.tRRD_L = (queue_main[0].tp.tRRD_L == 0)? queue_main[0].tp.tRRD_L : queue_main[0].tp.tRRD_L--;
	queue_main[0].tp.tRRD_S = (queue_main[0].tp.tRRD_S == 0)? queue_main[0].tp.tRRD_S : queue_main[0].tp.tRRD_S--;
	queue_main[0].tp.tRP = (queue_main[0].tp.tRP == 0)?  queue_main[0].tp.tRP: queue_main[0].tp.tRP--;
	queue_main[0].tp.tRFC = (queue_main[0].tp.tRFC == 0)? queue_main[0].tp.tRFC : queue_main[0].tp.tRFC--;
	queue_main[0].tp.tCWD = (queue_main[0].tp.tCWD == 0)?  queue_main[0].tp.tCWD: queue_main[0].tp.tCWD--;
	queue_main[0].tp.tCL = (queue_main[0].tp.tCL == 0)?  queue_main[0].tp.tCL: queue_main[0].tp.tCL--;
	queue_main[0].tp.tRCD = (queue_main[0].tp.tRCD == 0)?  queue_main[0].tp.tRCD: queue_main[0].tp.tRCD--;
	queue_main[0].tp.tWR = (queue_main[0].tp.tWR == 0)?  queue_main[0].tp.tWR: queue_main[0].tp.tWR--;
	queue_main[0].tp.tRTP = (queue_main[0].tp.tRTP == 0)?  queue_main[0].tp.tRTP: queue_main[0].tp.tRTP--;
	queue_main[0].tp.tCCD_L = (queue_main[0].tp.tCCD_L == 0)?  queue_main[0].tp.tCCD_L: queue_main[0].tp.tCCD_L--;
	queue_main[0].tp.tCCD_S = (queue_main[0].tp.tCCD_S == 0)?  queue_main[0].tp.tCCD_S: queue_main[0].tp.tCCD_S--;
	queue_main[0].tp.tCCD_L_WR = (queue_main[0].tp.tCCD_L_WR == 0)?  queue_main[0].tp.tCCD_L_WR: queue_main[0].tp.tCCD_L_WR--;
	queue_main[0].tp.tCCD_S_WR = (queue_main[0].tp.tCCD_S_WR == 0)?  queue_main[0].tp.tCCD_S_WR: queue_main[0].tp.tCCD_S_WR--;
	queue_main[0].tp.tBURST = (queue_main[0].tp.tBURST == 0)?  queue_main[0].tp.tBURST: queue_main[0].tp.tBURST--;
	queue_main[0].tp.tCCD_L_RTW = (queue_main[0].tp.tCCD_L_RTW == 0)?  queue_main[0].tp.tCCD_L_RTW: queue_main[0].tp.tCCD_L_RTW--;
	queue_main[0].tp.tCCD_S_RTW = (queue_main[0].tp.tCCD_S_RTW == 0)?  queue_main[0].tp.tCCD_S_RTW: queue_main[0].tp.tCCD_S_RTW--;
	queue_main[0].tp.tCCD_L_WTR = (queue_main[0].tp.tCCD_L_WTR == 0)?  queue_main[0].tp.tCCD_L_WTR: queue_main[0].tp.tCCD_L_WTR--;
	queue_main[0].tp.tCCD_S_WTR = (queue_main[0].tp.tCCD_S_WTR == 0)?  queue_main[0].tp.tCCD_S_WTR: queue_main[0].tp.tCCD_S_WTR--;

endfunction

endpackage