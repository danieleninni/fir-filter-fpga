-- Design and implementation of a reconfigurable FIR filter in FPGA
-- Students: Nagaro Gianmarco, Ninni Daniele, Rodrigues Vero Filho Emerson, Valentini Lorenzo

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.TYPES.ALL;

entity top is
  port (clock              : in  std_logic;
        mode_sel_in        : in  std_logic;
        uart_txd_in        : in  std_logic;
        led_setting_coeffs : out std_logic;
        led_ready          : out std_logic;
        led_filtering      : out std_logic;
        uart_rxd_out       : out std_logic);
end entity top;

architecture str of top is

  component uart_receiver is
    port (clock         : in  std_logic;
          uart_rx       : in  std_logic;
          valid         : out std_logic;
          received_data : out std_logic_vector(7 downto 0));
  end component uart_receiver;
  
  component fir_filter is
    port (clock     : in  std_logic;
          reset     : in  std_logic;
          coeffs    : in  coeff_array;
          data_in   : in  std_logic_vector(data_width-1 downto 0);
          valid_in  : in  std_logic;
          data_out  : out std_logic_vector(data_width-1 downto 0);
          valid_out : out std_logic);
  end component fir_filter;
  
  component uart_transmitter is
    port (clock        : in  std_logic;
          data_to_send : in  std_logic_vector(7 downto 0);
          data_valid   : in  std_logic;
          busy         : out std_logic;
          uart_tx      : out std_logic);
  end component uart_transmitter;
  
  signal reset        : std_logic;
  signal valid_in     : std_logic;
  signal data_in      : std_logic_vector(data_width-1 downto 0);
  signal coeffs       : coeff_array;
  signal data_out     : std_logic_vector(data_width-1 downto 0);
  signal valid_out    : std_logic;
  signal busy         : std_logic;
  signal n_coeffs_set : integer := 0; -- number of FIR coefficients already set
  
begin -- architecture str

  uart_receiver_1 : uart_receiver port map (clock         => clock,
                                            uart_rx       => uart_txd_in,
                                            valid         => valid_in,
                                            received_data => data_in);

  fir_filter_1 : fir_filter port map (clock     => clock,
                                      reset     => reset,
                                      coeffs    => coeffs,
                                      data_in   => data_in,    
                                      valid_in  => valid_in,
                                      data_out  => data_out,
                                      valid_out => valid_out);
  
  uart_transmitter_1 : uart_transmitter port map (clock        => clock,
                                                  data_to_send => data_out,
                                                  data_valid   => valid_out,
                                                  busy         => busy,
                                                  uart_tx      => uart_rxd_out);
  
  main : process (clock) is
  begin -- process main
    if rising_edge(clock) then
    
      -- filtering mode
      if mode_sel_in = '1' then
      
        led_setting_coeffs <= '0';
        led_ready          <= '0';
        led_filtering      <= '1';
        reset              <= '1';
        n_coeffs_set       <=  0;
        
      -- setting mode
      else
      
        led_setting_coeffs <= '1';
        led_filtering      <= '0';
        reset              <= '0';
      
        if n_coeffs_set = taps then
        
          led_ready <= '1';
          
        elsif valid_in = '1' then
        
          coeffs(n_coeffs_set) <= data_in;
          n_coeffs_set         <= n_coeffs_set + 1;
          led_ready            <= '0';
          
        end if;
      end if;
    end if;
  end process main;

end architecture str;