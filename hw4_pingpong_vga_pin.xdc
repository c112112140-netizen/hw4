set_property IOSTANDARD LVCMOS25 [get_ports clk]
set_property PACKAGE_PIN Y9 [get_ports clk]

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS25} [get_ports {rst}]

set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS25} [get_ports sw_r]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS25} [get_ports sw_l]


set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS25} [get_ports {led_r[0]}]
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS25} [get_ports {led_r[1]}]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS25} [get_ports {led_r[2]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS25} [get_ports {led_r[3]}]
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS25} [get_ports {led_r[4]}]
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS25} [get_ports {led_r[5]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS25} [get_ports {led_r[6]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS25} [get_ports {led_r[7]}]


set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS25}   [get_ports {hsync}]
set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS25}   [get_ports {vsync}]

set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS25}   [get_ports {vga_r[0]}]
set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS25}   [get_ports {vga_r[1]}]
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS25}   [get_ports {vga_r[2]}]
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS25} [get_ports {vga_r[3]}]

set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS25}  [get_ports {vga_g[0]}]
set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS25}  [get_ports {vga_g[1]}]
set_property -dict {PACKAGE_PIN AB1 IOSTANDARD LVCMOS25}  [get_ports {vga_g[2]}]
set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS25}  [get_ports {vga_g[3]}]

set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS25}  [get_ports {vga_b[0]}]
set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS25}  [get_ports {vga_b[1]}]
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS25}   [get_ports {vga_b[2]}]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS25}   [get_ports {vga_b[3]}]