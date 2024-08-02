---------------------------------------------------------------------------------------
-- CN3 glue logic                                                                    -- 
-- autoinitializing logic                                                            -- 
-- full synchronous logic design                                                     --                                                    
-- full VHDL-RTL style coding design                                                 --
-- target: ALTERA CPLD MAX II EPM570F256C5                                           --
-- project by Valerio Venturi ELMA Riva del Garda (TN) Italy (2009)                  --
-- Date: 16/10/2009                                                                  --
---------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types

-- global architecture 
entity v65c816_bench is
end v65c816_bench;

use work.v65c816;

architecture behavior of v65c816_bench is
  component v65c816 is
	  port(     clk0:    in STD_LOGIC;                       -- PHASE0 clock input
					 res:    in STD_LOGIC;                       -- reset input
					 irq:    in STD_LOGIC;                       -- interrupt request input
					 nmi:    in STD_LOGIC;                       -- not maskable interrupt input
					 rdy:    in STD_LOGIC;                       -- wait state input (read/write)
					  rw:   out STD_LOGIC;                       -- read/write out
					 vpa:   out STD_LOGIC;                       -- vpa
					 vda:   out STD_LOGIC;                       -- vda
					  vp:   out STD_LOGIC;                       -- vector pull
					 ope:   out STD_LOGIC;                       -- microcode end 
						e:   out STD_LOGIC;                       -- emulation (1)/native mode (0) 
						m:   out STD_LOGIC;                       -- M status	
						x:   out STD_LOGIC;                       -- X status	
				 op_exp:   out STD_LOGIC; 		                  -- two byte instruction running
					addr:   out STD_LOGIC_VECTOR(23 downto 0);   -- 16 bit address bus out
				data_in:    in STD_LOGIC_VECTOR(7 downto 0);    -- 8 bit input data bus
			  data_out:   out STD_LOGIC_VECTOR(7 downto 0);    -- 8 bit output data bus
				  a_reg:   out STD_LOGIC_VECTOR(15 downto 0);   -- 16 bit A register
				  x_reg:   out STD_LOGIC_VECTOR(15 downto 0);   -- 16 bit X register
				  y_reg:   out STD_LOGIC_VECTOR(15 downto 0);   -- 16 bit Y register
				  s_reg:   out STD_LOGIC_VECTOR(15 downto 0);   -- 16 bit S register
				 op_reg:   out STD_LOGIC_VECTOR(15 downto 0);   -- 16 bit Operand register	  
				  p_reg:   out STD_LOGIC_VECTOR(7 downto 0);    --  8 bit P register
				  k_reg:   out STD_LOGIC_VECTOR(7 downto 0);    --  8 bit K register
				  b_reg:   out STD_LOGIC_VECTOR(7 downto 0);    --  8 bit B register
				  o_reg:   out STD_LOGIC_VECTOR(7 downto 0);    --  8 bit Opcode register
				  mcode:   out STD_LOGIC_VECTOR(3 downto 0)     --  4 bit microcode sequence register
			);   
  end component;
  
  signal clk0,res,irq,nmi,rdy,rw,vpa,vda,vp,ope,e,m,x,op_exp:             STD_LOGIC;
  signal addr:                                                            STD_LOGIC_VECTOR(23 downto 0);
  signal data_in:                                                         STD_LOGIC_VECTOR(7 downto 0); 
  signal data_out:                                                        STD_LOGIC_VECTOR(7 downto 0); 
  signal a_reg:                                                           STD_LOGIC_VECTOR(15 downto 0);   -- 16 bit A register
  signal x_reg:                                                           STD_LOGIC_VECTOR(15 downto 0);   -- 16 bit X register
  signal y_reg:                                                           STD_LOGIC_VECTOR(15 downto 0);   -- 16 bit Y register
  signal s_reg:                                                           STD_LOGIC_VECTOR(15 downto 0);   -- 16 bit S register
  signal op_reg:                                                          STD_LOGIC_VECTOR(15 downto 0);   -- 16 bit Operand register	  
  signal p_reg:                                                           STD_LOGIC_VECTOR(7 downto 0);    --  8 bit P register
  signal k_reg:                                                           STD_LOGIC_VECTOR(7 downto 0);    --  8 bit K register
  signal b_reg:                                                           STD_LOGIC_VECTOR(7 downto 0);    --  8 bit B register
  signal o_reg:                                                           STD_LOGIC_VECTOR(7 downto 0);    --  8 bit Opcode register
  signal mcode:                                                           STD_LOGIC_VECTOR(3 downto 0);    --  4 bit microcode sequence register

  constant clk_period: time := 50 ns; 
  --signal clock: STD_LOGIC := '0';
  
  begin
  u1:   v65c816 port map(
                         clk0,
								 res,
								 irq,
								 nmi,
								 rdy,
								 rw,
								 vpa,
								 vda,
								 vp,
								 ope,
								 e,
								 m,
								 x,
								 op_exp,
                         addr,
								 data_in,
								 data_out,
                         a_reg,
				             x_reg,
				             y_reg,
				             s_reg,
				             op_reg,
				             p_reg,
				             k_reg,
				             b_reg,
				             o_reg,
				             mcode
					         );
  
  
  tst_clock: process                                       -- 10 MHZ (period 100 ns) clock generation
             variable clktmp: STD_LOGIC := '0';
             begin
               clktmp := not clktmp;
               clk0 <= clktmp;
             wait for 50 ns;
             end process;
         
  stimulus:  process
             begin
               -- signal initialization before reset
               res <= '0';
			      irq <= '1';
			      nmi <= '1';
			      rdy <= '1';
               wait for 350 ns;

               -- device reset completed
               res <= '1';                                                                          
               wait for 600 ns;
               data_in <= "00000000";                      -- fetch lsb reset PC vector 0x00
               wait for 50 ns;

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "11000001";                      -- fetch msb reset PC vector 0xc1 (0xc100)
               wait for 70 ns;
               data_in <= "ZZZZZZZZ";  

               wait for 50 ns;
               data_in <= "00011000";                      -- CLC
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               wait for 50 ns;
               data_in <= "11111011";                      -- XCE
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               wait for 50 ns;
               data_in <= "ZZZZZZZZ";                      -- XCE execution
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  
					
               wait for 50 ns;
               data_in <= "11000010";                      -- REP #%00100000
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               wait for 50 ns;
               data_in <= "00100000";                      -- $20
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "10101001";                      -- LDA #$0000
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               wait for 50 ns;
               data_in <= "00000000";                      -- $00
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               wait for 50 ns;
               data_in <= "00000000";                      -- $00
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  
               
               wait for 50 ns;
               data_in <= "00011000";                      -- CLC
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "01101001";                      -- ADC #$0001
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "00000001";                      -- $01
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "00000000";                      -- $00
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "00111000";                      -- SEC
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "11101001";                      -- SBC #0002
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "00000010";                      -- $02
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "00000000";                      -- $00
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "11101010";                      -- NOP
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "11101010";                      -- NOP
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "11101010";                      -- NOP
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "11101010";                      -- NOP
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "11101010";                      -- NOP
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  

               data_in <= "ZZZZZZZZ";  
               wait for 50 ns;
               data_in <= "11101010";                      -- NOP
               wait for 50 ns;
               data_in <= "ZZZZZZZZ";  


               --wait for 1000000 ns;
               wait;                              
            end process;
end behavior;


            
