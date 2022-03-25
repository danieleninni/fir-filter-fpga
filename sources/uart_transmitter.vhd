-- Design and implementation of a reconfigurable FIR filter in FPGA
-- Students: Nagaro Gianmarco, Ninni Daniele, Rodrigues Vero Filho Emerson, Valentini Lorenzo

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_transmitter is
  port (clock        : in  std_logic;
        data_to_send : in  std_logic_vector(7 downto 0);
        data_valid   : in  std_logic;
        busy         : out std_logic;
        uart_tx      : out std_logic);
end entity uart_transmitter;

architecture rtl of uart_transmitter is

  component baudrate_generator is
    port (clock        : in  std_logic;
          baudrate_out : out std_logic);
  end component baudrate_generator;

  type state_t is (idle_s, data_valid_s, start_s, bit0_s, bit1_s, bit2_s, bit3_s, bit4_s, bit5_s, bit6_s, bit7_s, bit8_s, stop_s);
  signal state : state_t := idle_s;
  
  signal baudrate_out : std_logic;
  
begin -- architecture rtl

  baudrate_generator_1 : baudrate_generator port map (clock        => clock,
                                                      baudrate_out => baudrate_out);

  main_state_machine : process (clock) is
  begin -- process main_state_machine
    if rising_edge(clock) then
      case state is
      
        when idle_s =>
          busy    <= '0';
          uart_tx <= '1';
          if data_valid = '1' then
            state <= data_valid_s;
          end if;
          
        when data_valid_s =>
          busy <= '1';
          if baudrate_out = '1' then
            state <= start_s;
          end if;
          
        when start_s =>
          uart_tx <= '0';
          if baudrate_out = '1' then
            state <= bit0_s;
          end if;
          
        when bit0_s =>
          uart_tx <= data_to_send(0);
          if baudrate_out = '1' then
            state <= bit1_s;
          end if;
          
        when bit1_s =>
          uart_tx <= data_to_send(1);
          if baudrate_out = '1' then
            state <= bit2_s;
          end if;
          
        when bit2_s =>
          uart_tx <= data_to_send(2);
          if baudrate_out = '1' then
            state <= bit3_s;
          end if;
          
        when bit3_s =>
          uart_tx <= data_to_send(3);
          if baudrate_out = '1' then
            state <= bit4_s;
          end if;
          
        when bit4_s =>
          uart_tx <= data_to_send(4);
          if baudrate_out = '1' then
            state <= bit5_s;
          end if;
          
        when bit5_s =>
          uart_tx <= data_to_send(5);
          if baudrate_out = '1' then
            state <= bit6_s;
          end if;
          
        when bit6_s =>
          uart_tx <= data_to_send(6);
          if baudrate_out = '1' then
            state <= bit7_s;
          end if;
          
        when bit7_s =>
          uart_tx <= data_to_send(7);
          if baudrate_out = '1' then
            state <= stop_s;
          end if;
          
        when stop_s =>
          uart_tx <= '1';
          if baudrate_out = '1' then
            state <= idle_s;
          end if;
          
        when others => null;
        
      end case;
    end if;
  end process main_state_machine;

end architecture rtl;