<div align="center"> 

# 64-to-1 Multiplexer (MUX) - Complete RTL-to-GDSII ASIC Flow 🚀 
### A Silicon Journey: From Behavioral Verilog to Sky130 Manufacturing-Ready Layout 

[![OpenLane](https://img.shields.io/badge/OpenLane-Automated%20Flow-blue.svg)](https://github.com/The-OpenROAD-Project/OpenLane)
[![PDK](https://img.shields.io/badge/PDK-Sky130-red.svg)](https://github.com/google/skywater-pdk) 
[![Language](https://img.shields.io/badge/Language-Verilog-blueviolet.svg)](#) 
[![Status](https://img.shields.io/badge/Status-DRC%20%26%20LVS%20Clean-success.svg)](#) 

*Documenting the complete physical design realization of a 64-to-1 Multiplexer using the open-source OpenLane toolchain and SkyWater 130nm standard cell library.* 

<img src="mux64to1%20ss/klayout.png" alt="Final KLayout GDS Layout" width="800px"> 

--- 

**[Explore the Visual Journey](#-the-rtl-to-gdsii-visual-journey) • [Reproduce the Flow](#-how-to-reproduce) • [Repository Structure](#-repository-structure)** 

</div> 

--- 

## 💡 Project Overview & Physical Constraints 

A **64-to-1 Multiplexer (MUX)** serves as a fundamental combinational routing block where one of 64 parallel input lines is selected and directed to a single output line based on a 6-bit select bus. While architecturally straightforward, executing its physical implementation through an ASIC backend exposes critical design trade-offs regarding logic tree depth, routing congestion across 64 input signals, power distribution, and core area allocation. 

This project drives a behavioral Verilog model of a 64-to-1 MUX completely through the automated **OpenLane** flow to achieve a tapeout-ready macro layout targeting the **SkyWater 130nm (sky130A)** open PDK. 

--- 

## 🛠️ Tools & Technology Stack 

| Flow Stage | Open-Source Tool / PDK | Function | 
| :--- | :--- | :--- | 
| **Process Node** | SkyWater 130nm (`sky130A`) | Target silicon manufacturing technology | 
| **Functional Verification** | Icarus Verilog (`iverilog`) & GTKWave | RTL simulation and waveform debugging | 
| **Logic Synthesis** | Yosys & abc | Gate-level netlist generation & tech-mapping | 
| **Floorplan & Placement** | OpenROAD | Core/die initialization, PDN, and cell placement | 
| **Clock Tree & Routing** | OpenROAD (TritonRoute) | Global and detailed interconnect routing | 
| **Physical Verification** | Magic, KLayout & Netgen | Signoff DRC checks, layout viewing, and LVS netlist comparison | 

--- 

## 📖 The RTL-to-GDSII Visual Journey 

Follow the automated physical design pipeline execution step-by-step with verified visual checkpoints from our runtime workspace: 

### 1️⃣ RTL Design & Functional Verification 

The behavioral logic of the 64-to-1 multiplexer was validated using a comprehensive testbench (`mux64to1tb.v`). Waveform inspection confirms flawless output transitions across varied select input vectors (`sel[5:0]`) with zero delay overhead in behavioral simulation. 

<p align="center"> 
  <img src="mux64to1%20ss/waveforms.png" width="90%" alt="GTKWave Verification Waveforms"> 
</p> 

### 2️⃣ Logic Synthesis (Yosys) 

The Verilog source description is translated into structural gates. Cells are cleanly mapped to the specific standard cells of the `sky130_fd_sc_hd` (high density) library. 

**Synthesis Area Statistics (`1-synthesis.AREA_0.stat.rpt`):**
* **Number of wires:** 63
* **Number of cells:** 61 (Includes `mux2_2`, `mux4_2`, `a21o_2`, `a21oi_2`, etc.)
* **Total Chip Area:** `659.382400 μm²`

**Power Analysis (`2-syn_sta.power.rpt` @ Typical Corner):**
* **Internal Power:** `1.79e-05 W` (63.8%)
* **Switching Power:** `1.02e-05 W` (36.2%)
* **Leakage Power:** `2.25e-10 W` (0.0%)
* **Total Power:** `2.81e-05 W` (28.1 μW)

<p align="center"> 
  <img src="mux64to1%20ss/area.png" width="49%" alt="Synthesis Area Report"> 
  <img src="mux64to1%20ss/power.png" width="49%" alt="Synthesis Power Report"> 
</p> 

### 3️⃣ Floorplanning & Power Delivery Network (PDN) 

The core boundary is initialized and I/O pad/pin groups are arranged along the periphery. The PDN macro generation drops vertical and horizontal power stripes (`VDD`/`GND`) to guarantee clean rail distribution across the logic matrix. 

> 💡 **Pro-Tip for Interactive Workspace Viewing:** 
> To explore the layout database interactively in 3D using OpenROAD GUI: 
> 1. Start the container: `make mount` 
> 2. Open the interface: `openroad -gui` 
> 3. Source the layout database file: `read_db runs/<run_name>/results/floorplan/<file_name>.odb` 

<p align="center"> 
  <img src="mux64to1%20ss/floorplanning.png" width="80%" alt="OpenROAD Floorplan Window"> 
</p> 

### 4️⃣ Global & Detailed Placement 

Standard cells are legally localized into the core rows. The placement tool evaluates cell congestion and minimizes initial wire length to prevent localized routing density bottlenecks caused by the multi-bit input lines. 

<p align="center"> 
  <img src="mux64to1%20ss/placement.png" width="80%" alt="Global Placement Overview"> 
</p> 

### 5️⃣ Interconnect Routing 

Signal routing is successfully resolved over multi-layer metal grids. Global routing budgets the paths, while detailed routing maps out the exact tracks, preserving minimum manufacturing spaces and clearing antenna rule hazards. 

<p align="center"> 
  <img src="mux64to1%20ss/routing.png" width="80%" alt="Routed Netlist OpenROAD GUI View"> 
</p> 

### 6️⃣ Physical Signoff & Manufacturing Verification (DRC/LVS) 

The finished layout was exported to Magic and KLayout for strict physical layout checking. The design achieved flawless verification closure, yielding clean **0 DRC** anomalies, completely coherent **LVS match** alignment (204 nets), and **0 Antenna** violations. 

<p align="center"> 
  <img src="mux64to1%20ss/drc.png" width="90%" alt="Manufacturability Summary Report Log"> 
</p> 

--- 

## 📂 Repository Structure 

```text 
├── mux64to1 ss/         # Verified visual logs, waves, and layout screenshots 
├── src/                 # Behavioral Verilog files (*.v) and simulation testbenches 
├── config.json          # OpenLane floorplan constraints and design configurations 
├── mux64to1.gds         # Exported binary stream format for foundry fabrication 
└── README.md            # You are here!<div align="center"> 
```
## 🚀 How to Reproduce

Rebuild this physical layout blueprint on your local environment:

## Prerequisites:

1.Linux OS (Ubuntu environment recommended)
2.Docker engine installed and configured
3.OpenLane workspace clone with configured Sky130 PDK

### Step 1: Execute Functional Verification

Verify the behavioral netlist prior to logic translation:

Compile design and testbench modules
```
iverilog -o src/mux.vvp src/mux64to1.v src/mux64to1tb.v
````
Execute simulation runtime to output VCD dump
```
vvp src/mux.vvp
```
Open wave structures visually
```
gtkwave src/mux64.vcd
```
### Step 2: Run the Physical Design Pipeline

Move this design directory inside your native OpenLane installation route under <OpenLane_Root>/designs/.

1. Mount the interactive OpenLane environment container.
```
make mount
```
2. Run the automated layout generation script
```
./flow.tcl -design mux64to1
```
## 🤝 Acknowledgments

1.Google / SkyWater Foundation: For lowering the barrier of entry by open-sourcing the 130nm PDK.

2.The OpenROAD Project: For developing robust, fully automated EDA placement, routi
