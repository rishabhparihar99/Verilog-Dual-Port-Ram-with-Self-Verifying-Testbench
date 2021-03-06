module true_dual_port_ram_tb();


  reg [7:0]data_a,data_b;
  reg [5:0]addr_a,addr_b;
  reg we_a,we_b,clk;
  wire [7:0]q_a,q_b;

 parameter clock = 100,
           thold = 5,
           tsetup = 5;
 
integer i;
true_dual_port_ram DUT(data_a,addr_a,we_a,q_a,data_b,addr_b,we_b,q_b,clk);

always
   begin
     #(clock/2) clk = 1'b0;
     #(clock/2) clk = 1'b1;
   end

task datain_1_test;
input [7:0]data_bus;
begin
   #(clock - thold - tsetup);
    data_a = data_bus;
    we_a = 1'b1;
    addr_a = 6'd5;
    @(posedge clk);
     #(thold);
         if(q_a !== data_a && (DUT.ram[addr_a] == data_a)) begin
              $display("dataport_1 is not working fine");
               $display("Error at time %t",$time);
               $stop;
          end
    $display("dataport_1 is working fine");
    {data_a,data_bus} <= 16'bx;
     addr_a <= 6'dx;
     we_a <= 1'bx;
    #(clock - thold - tsetup);
     
end
endtask

task datain_2_test;
input [7:0]data_bus;
begin
    data_b = data_bus;
    we_b = 1'b1;
    addr_b = 6'd5;
    @(posedge clk);
     #(thold);
         if(q_b !== data_b && (DUT.ram[addr_b] == data_b)) begin
              $display("dataport_2 is not working fine");
               $display("Error at time %t",$time);
               $stop;
          end
    $display("dataport_2 is working fine");
    {data_b,data_bus} <= 16'bx;
     addr_b <= 6'dx;
     we_b <= 1'bx;
    #(clock - thold - tsetup);
end
endtask


task address_port_1_test(input [5:0]bus);
begin
    we_a = 1'b1;
    data_a = 8'd63;
    addr_a  = bus;
    @(posedge clk);
    #(thold);
        if(DUT.ram[bus[5:0]] !== data_a) begin
             $display("AddressBus1 is not working fine");
             $display("Error at time %t",$time);
             $stop;
         end
    $display("Address1 is working fine");
    {addr_a,bus} = 12'dx;
    data_a = 8'dx;
    we_a = 1'bx;

 #(clock - thold - tsetup);
end
endtask

    
task address_port_2_test(input [5:0]bus);
begin
    we_b = 1'b1;
    data_b = 8'd63;
    addr_b = bus;
    @(posedge clk);
    #(thold);
        if(DUT.ram[bus[5:0]] !== data_b) begin
             $display("AddressBus2 is not working fine");
             $display("Error at time %t",$time);
             $stop;
         end
    $display("Address2 is working fine");
    {addr_b,bus} = 12'dx;
    data_b = 8'dx;
    we_b = 1'bx;

 #(clock - thold - tsetup);
end
endtask

task write_enb_1_test(input w);
begin
  we_a = w;
  addr_a = 6'd14;
  data_a = 8'd65;
  @(posedge clk);
  #(thold);
     if(q_a !== data_a) begin
             $display("Write enable 1 not working");
             $display("Error at %0t",$time);
             $stop;
         end
   $display("write enable 1 working");
   {we_a,w} = 2'bx;
   {addr_a,data_a} = 14'dx;
     #(clock - thold - tsetup);
   end
endtask

task write_enb_2_test(input w);
begin
  we_b = w;
  addr_b = 6'd14;
  data_b = 8'd65;
  @(posedge clk);
  #(thold);
     if(q_b !== data_b) begin
             $display("Write enable 2 not working");
             $display("Error at %0t",$time);
             $stop;
         end
   $display("write enable 2 working");
   {we_b,w} = 2'bx;
   {addr_b,data_b} = 14'dx;
     #(clock - thold - tsetup);
   end
endtask
         
// Generating stimulus
initial begin
 datain_1_test(8'd34);
 datain_2_test(8'd59);
 address_port_1_test(6'd16);
 address_port_2_test(6'd26);
 write_enb_1_test(1'b1);
 write_enb_2_test(1'b1);
end


initial #900 $finish;


endmodule 