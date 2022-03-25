-- Design and implementation of a reconfigurable FIR filter in FPGA
-- Students: Nagaro Gianmarco, Ninni Daniele, Rodrigues Vero Filho Emerson, Valentini Lorenzo

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sampler_generator is
  port (clock        : in  std_logic;
        uart_rx      : in  std_logic;
        baudrate_out : out std_logic);
end entity sampler_generator;

architecture rtl of sampler_generator is

  type state_t is (idle_s, start_s, bit0_s, bit1_s, bit2_s, bit3_s, bit4_s, bit5_s, bit6_s, bit7_s, bit8_s, stop_s);
  signal state : state_t := idle_s;

  signal counter        : unsigned(10 downto 0) := (others => '0');
  signal delay_counter  : unsigned(10 downto 0) := (others => '0');
  constant divisor      : unsigned(10 downto 0) := to_unsigned(867, 11);
  constant half_divisor : unsigned(10 downto 0) := to_unsigned(433, 11);
  signal busy           : std_logic             := '0';
  signal pulse_out      : std_logic;
  signal enable_counter : std_logic             := '0';
  signal enable_delay   : std_logic             := '0';
  
begin

  pulse_generator : process (clock) is
  begin -- process pulse_generator
    if rising_edge(clock) then
      if enable_counter = '1' then
        counter <= counter + 1;
        if counter = divisor then
          pulse_out <= '1';
          counter   <= (others => '0');
        else
          pulse_out <= '0';
        end if;
      else
        counter <= (others => '0');
      end if;
    end if;
  end process pulse_generator;

  state_machine : process (clock) is
  begin -- process state_machine
    if rising_edge(clock) then
      case state is
      
        when idle_s =>
          enable_counter <= '0';
          if uart_rx = '0' then
            state <= start_s;
          end if;
          
        when start_s =>
          -- enable baudrate_generator
          enable_counter <= '1';
          if pulse_out = '1' then
            state <= bit0_s;
          end if;
          
        when bit0_s =>
          if pulse_out = '1' then
            state <= bit1_s;
          end if;
          
        when bit1_s =>
          if pulse_out = '1' then
            state <= bit2_s;
          end if;
          
        when bit2_s =>
          if pulse_out = '1' then
            state <= bit3_s;
          end if;
          
        when bit3_s =>
          if pulse_out = '1' then
            state <= bit4_s;
          end if;
          
        when bit4_s =>
          if pulse_out = '1' then
            state <= bit5_s;
          end if;
          
        when bit5_s =>
          if pulse_out = '1' then
            state <= bit6_s;
          end if;
          
        when bit6_s =>
          if pulse_out = '1' then
            state <= bit7_s;
          end if;
          
        when bit7_s =>
          if pulse_out = '1' then
            state <= idle_s;
          end if;
          
        when others => null;
        
      end case;
    end if;
  end process state_machine;

  delay_line : process (clock) is
  begin -- process delay_line
    if rising_edge(clock) then
      if pulse_out = '1' then
        -- start count
        enable_delay <= '1';
      end if;
      if delay_counter = half_divisor then
        enable_delay <= '0';
        baudrate_out <= '1';
      -- end count
      else
        baudrate_out <= '0';
      end if;
      if enable_delay = '1' then
        delay_counter <= delay_counter + 1;
      else
        delay_counter <= (others => '0');
      end if;
    end if;
  end process delay_line;

end architecture rtl;