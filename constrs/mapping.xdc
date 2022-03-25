# Design and implementation of a reconfigurable FIR filter in FPGA
# Students: Nagaro Gianmarco, Ninni Daniele, Rodrigues Vero Filho Emerson, Valentini Lorenzo

## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 }      [get_ports { clock }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clock }];

## Switches
set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 }      [get_ports { mode_sel_in }]; #IO_L12N_T1_MRCC_16 Sch=sw[0]

## RGB LEDs
set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 }      [get_ports { led_filtering }]; #IO_L18N_T2_35 Sch=led0_b
set_property -dict { PACKAGE_PIN F6    IOSTANDARD LVCMOS33 }      [get_ports { led_ready }]; #IO_L19N_T3_VREF_35 Sch=led0_g
set_property -dict { PACKAGE_PIN G6    IOSTANDARD LVCMOS33 }      [get_ports { led_setting_coeffs }]; #IO_L19P_T3_35 Sch=led0_r

## USB-UART Interface
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 }      [get_ports { uart_rxd_out }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 }      [get_ports { uart_txd_in }]; #IO_L14N_T2_SRCC_16 Sch=uart_txd_in