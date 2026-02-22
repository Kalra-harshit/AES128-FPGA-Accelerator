# AES128-FPGA-Accelerator
# Hardware-Accelerated AES-128 Image Encryptor

![Platform](https://img.shields.io/badge/Platform-Xilinx_FPGA-blue)
![Language](https://img.shields.io/badge/Language-Verilog_HDL-green)
![Software](https://img.shields.io/badge/Interface-MATLAB_GUI-orange)

## 📌 Overview
This repository contains the Register-Transfer Level (RTL) design, verification environment, and software interface for a **high-throughput, pipelined AES-128 encryption core**. Designed for Xilinx FPGA platforms, this project targets real-time static image encryption applications where software-based (CPU) processing suffers from high latency and power bottlenecks. The cryptographic primitive strictly adheres to the **FIPS-197 standard**.

## ✨ Key Features
* **Pipelined Architecture:** A 10-stage hardware pipeline executing the complete AES algorithm in a continuous data flow, achieving massive parallelism and high throughput (1 block per clock cycle after initial latency).
* **Hardware-Level Security:** Isolates the encryption process from OS vulnerabilities, making it ideal for Edge AI, biometric sensors, and industrial IoT nodes.
* **Custom UART Controller:** A robust Finite State Machine (FSM) managing serial data synchronization and buffering between the host PC and the FPGA.
* **MATLAB GUI Dashboard:** A custom software interface built with App Designer for loading raw images, transmitting them to the hardware, and visualizing the encrypted output.
* **Bit-Perfect Verification:** An automated testbench comparing hardware simulation waveforms against a mathematical MATLAB Golden Model.

## 🏗️ System Architecture



The core is designed using a bottom-up modular approach:
1. **Sub-modules:** Individual Verilog modules for `SubBytes` (S-Box), `ShiftRows`, and `MixColumns`.
2. **Round Logic:** Encapsulated into a generic `one_round` module.
3. **Pipeline Integration:** Ten instantiated rounds separated by pipeline registers to minimize the critical path and maximize maximum clock frequency (Fmax).



## 📂 Repository Structure
```text
📦 AES128-FPGA-Accelerator
 ┣ 📂 rtl             # Synthesizable Verilog source files (AES core, UART, FSM)
 ┣ 📂 tb              # Verilog testbenches and memory (.mem) files for simulation
 ┣ 📂 constraints     # Xilinx constraints file (.xdc) for pin mapping and timing
 ┣ 📂 software        # MATLAB Golden Model scripts and GUI App Designer files
 ┣ 📂 docs            # Block diagrams, FSM state charts, and project reports
 ┗ 📜 README.md       # Project documentation
