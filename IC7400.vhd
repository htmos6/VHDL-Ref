----------------------------------------------------------------------------------
-- Company: xx
-- Engineer: Mehmet Arslan
-- 
-- Create Date: 23.06.2024 22:43:40
-- Design Name: 
-- Module Name: Structure of VHDL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity IC7400 is
generic 
(
	c_clkfreq : integer := 100_000_000;
	c_sclkfreq : integer := 1_000_000;
	c_i2cfreq : integer := 400_000;
	
	c_bitnum : integer := 8;
	c_is_sim : boolean := false;

	c_config_reg : std_logic_vector (7 downto 0) := X"A3"
);
port 
(
	input1_i : in std_logic_vector (c_bitnum-1 downto 0);
	input2_i : in std_logic;
	clk : in std_logic;
	
	output1_o : out std_logic;
	output2_o : out std_logic
);
end IC7400;


architecture Behavioral of IC7400 is


	component FullAdder is
	port 
	(
		a_i : in std_logic;
		b_i : in std_logic;
		carry_i : in std_logic;
		
		out_o : out std_logic;
		carry_o : out std_logic
	);
	end component;


	constant c_constant1 : integer := 30;
	constant c_timer_1ms_slim : integer := c_clkfreq / 1000;
	constant c_constant2 : std_logic_vector (c_bitnum-1 downto 0) := (others => '0');


	type t_state is (S_START, S_OPERATION, S_TERMINATE, S_IDLE);
	type r_records is record
		param1 : std_logic;
		param2 : std_logic_vector (3 downto 0);
	end record;


	subtype t_decimal_digit is integer range 0 to 9;
	subtype t_byte is std_logic_vector (7 downto 0);


	signal s0 : std_logic_vector (c_bitnum-1 downto 0); -- signal without initialization
	signal s1 : std_logic_vector (c_bitnum-1 downto 0) := X"00"; -- signal with initialization
	signal s2 : integer range 0 to 255 := 0; -- integer signal with range limit, 8-bit HW
	signal s3 : integer := 0; -- integer signal without range limit , 32-bit HW
	signal s4 : std_logic := '0';
	signal state : t_state := S_START;
	signal s6 : r_records;
	signal opcode : t_byte := X"BA";
	signal bcd : t_decimal_digit := 9;

begin

	
	s6.param1 <= '1';
	s6.param2 <= x"5";


    -- for .. generate structure in vhdl
	N_BIT_ADDER : for k in 0 to N-1 generate

	n_bit_adder_k : FullAdder
	port map 
	(
		a_i => a_i(k),
		b_i => b_i(k),
		carry_i => temp(k),
		
		out_o => sum(k),
		carry_o => temp(k+1)
	);
	end generate N_BIT_ADDER;


	P_COMBINATIONAL : process (s0, state, input1_i, input2_i)
	begin
		if (s0 < 30) then
			s1 <= x"01";
		elsif (s0 < 40) then
			s1 <= x"02";
		else 
			s1 <= x"03";
		end if;
		
		
		case state is
			when S_START =>
				s0	<= x"01";
			when S_OPERATION =>
				s0	<= x"02";
			when S_TERMINATE =>
				s0	<= x"03";
			when others =>
				s0	<= x"04";
		end case;
		
	    -- No error. Uses second assignment.
		s4	<= (input1_i(1) and input1_i(2)) xor input2_i;
		s4	<= (input1_i(1) or input1_i(2)) xnor input2_i;	-- NOT multiple driven net

	end process P_COMBINATIONAL;

	P_SEQUENTIAL : process (clk)
	begin
		if rising_edge(clk) then 
		
		
		end if;
	
	end process P_SEQUENTIAL;



end Behavioral;