-- Design and implementation of a reconfigurable FIR filter in FPGA
-- Students: Nagaro Gianmarco, Ninni Daniele, Rodrigues Vero Filho Emerson, Valentini Lorenzo

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

package TYPES is

  constant taps         : integer := 35;                                                         -- number of FIR coefficients
  constant coeff_width  : integer := 8;                                                          -- width of each FIR coefficient
  constant data_width   : integer := 8;                                                          -- width of input/output data
  constant result_width : integer := data_width + coeff_width + integer(ceil(log2(real(taps)))); -- width of FIR filter result
  
  type coeff_array   is array (0 to taps-1) of std_logic_vector(coeff_width-1 downto 0);         -- array of FIR coefficients
  type data_array    is array (0 to taps-1) of signed(data_width-1 downto 0);                    -- array of data
  type product_array is array (0 to taps-1) of signed((data_width + coeff_width)-1 downto 0);    -- array of (coefficient * data) products
  
end package TYPES;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use WORK.TYPES.ALL;

entity fir_filter is
  port (clock     : in  std_logic;
        reset     : in  std_logic;
        coeffs    : in  coeff_array;
        data_in   : in  std_logic_vector(data_width-1 downto 0);
        valid_in  : in  std_logic;
        data_out  : out std_logic_vector(data_width-1 downto 0);
        valid_out : out std_logic);
end fir_filter;

architecture Behavioral of fir_filter is

  signal data_pipeline : data_array    := (others => (others => '0'));
  signal products      : product_array := (others => (others => '0'));

begin

  main : process (clock, reset) is
  
  variable result : signed(result_width-1 downto 0);
  
  begin -- process main
    if reset = '0' then
    
      data_pipeline <= (others => (others => '0'));
      products      <= (others => (others => '0'));
      result        := (others => '0'); 
  
    elsif rising_edge(clock) then
    
      if valid_in = '1' then
  
        data_pipeline <= signed(data_in) & data_pipeline(0 to taps-2); -- shift old data inside data_pipeline to insert data_in
        
        result := (others => '0');                                     -- initialize result to 0
        for i in 0 to taps-1 loop                                      -- for each FIR coefficient
          products(i) <= signed(coeffs(i)) * data_pipeline(i);         -- compute product
          result      := result + products(i);                         -- add product to result
        end loop;
        
        data_out  <= std_logic_vector(resize(shift_right(result, data_width-1), data_width));
        valid_out <= '1';
        
      else
        
        valid_out <= '0';
        
      end if;
    end if;
  end process main;

end Behavioral;