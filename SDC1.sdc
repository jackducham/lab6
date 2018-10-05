# Create a 50 MHz clock
create_clock -name {Clk} -period 20ns -waveform {0.000 5.000}
# Apply clock to all ports in top-level file with the name "Clk"
[get_ports {Clk}]