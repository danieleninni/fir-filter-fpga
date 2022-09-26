# Design and implementation of a reconfigurable FIR filter in FPGA

<p align="center">
<b>Group members</b> // Gianmarco Nagaro Quiroz, Daniele Ninni, Lorenzo Valentini, Emerson Rodriguez Vero Filho
</p>

This is our final project for *Management and Analysis of Physics Dataset (Module A)*.

<br>

## Abstract

FIR filters are among the most commonly used filters in signal processing. In this report the design and implementation of a FIR
filter in FPGA is discussed. The performance of the implementation is evaluated by analyzing the response of the filter to various
input sample signals generated in a Python environment. A USB serial interface, managed by a UART, carries the communication
between computer and FPGA. The implementation in question allows updating the values of the FIR coefficients without having
to rewrite the bitstream and, consequently, without having to reprogram the FPGA. The output of the FPGA is in agreement with
the output of the Python implementation of the same filter, thus proving the goodness of the FPGA implementation. Furthermore,
both outputs resemble the noiseless input signal, which proves that the filtering process respects all the characteristics established
in the design phase.

<br>

## File structure

```
.
├── constrs
│   └── mapping.xdc                             (constraints file)
|
├── img                                         (images)
│   ├── fir_coefficients.png
│   ├── frequency_response.png
│   ├── gaussian_pulse.png
│   ├── sinusoidal_wave.png
│   ├── sinusoidal_wave_with_unit_impulse.png
│   ├── square_wave.png
│   └── triangular_wave.png
|
├── sources                                     (implementation of the FIR filter)
|   ├── baudrate_generator.vhd
|   ├── fir_filter.vhd
|   ├── sampler_generator.vhd
|   ├── top.vhd
|   ├── uart_receiver.vhd
|   └── uart_transmitter.vhd
|
├── fir_filter_fpga.ipynb                       (demo notebook)
|
└── report.pdf                                  (report of this project)
```

***

<h5 align="center">Management and Analysis of Physics Dataset (Module A)<br>University of Padua, A.Y. 2021/22</h5>

<p align="center">
  <img src="https://user-images.githubusercontent.com/62724611/166108149-7629a341-bbca-4a3e-8195-67f469a0cc08.png" alt="" height="70"/>
</p>