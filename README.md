##UART Hardware Communication Protocol Implementation
This project implements a Universal Asynchronous Receiver-Transmitter (UART) communication protocol using SystemVerilog on Basys3 boards. The goal is to demonstrate expertise in sequential logic, state machines, and read/write control logic.

#Overview
The UART module facilitates asynchronous serial communication in full-duplex mode, allowing data transmission and reception simultaneously between two Basys3 boards. The implementation adheres to standard UART specifications, featuring 8 data bits per transmission, no parity bit, and 2 stop bits.

##Project Stages
#Stage 1: UART Device
Implement a simplified UART device with transmitter and receiver modules.
Utilize the rightmost 8 switches for input to the transmitter buffer (TXBUF).
Use buttons for loading data, initiating transmission, and displaying received data on LEDs.
#Stage 2: Register Files
Modify internal data storage to include 4-byte memory for transmitted and received data.
Implement a FIFO structure for receiver register files, discarding earliest data if necessary.
#Stage 3: Display on 7-Segment
Visualize stored data on the 4-digit 7-segment display of Basys3 boards.
Implement functionality to scroll through and display different sets of data.
#Stage 4: Automatic Transfer
Introduce a mode to automatically send the entire transmitter array (TXBUF) with a single button press.
Retain the ability to manually transmit one byte at a time.
#How to Use
Connect two Basys3 boards using jumper wires and Pmod headers.
Utilize buttons and switches for input, transmission initiation, and display control.
Test the implementation with another Basys3 board to observe bidirectional communication.
#Important Notes
Follow project stages for incremental implementation and issue identification.
Utilize Vivado for synthesis and adhere to recommended configurations.
Connect grounds of two boards while testing UART.
#Project Report
Detailed explanations, RTL schematics, state diagrams, block diagrams, testbenches (optional), and references are included in the project report.
Note: Ensure to connect grounds of two boards while testing UART!
