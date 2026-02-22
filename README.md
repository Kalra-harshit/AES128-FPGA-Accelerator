# Hardware AES-128 Encryption Core

![Platform](https://img.shields.io/badge/Platform-Xilinx_FPGA-blue)
![Language](https://img.shields.io/badge/Language-Verilog_HDL-green)
![Software](https://img.shields.io/badge/Reference-Python-yellow)
![Status](https://img.shields.io/badge/Status-In_Development-orange)

## 📌 Overview
This repository contains the Register-Transfer Level (RTL) design and simulation environment for a hardware-based **AES-128 encryption core**. Designed for Xilinx FPGA platforms, this project implements the fundamental cryptographic primitives strictly adhering to the **FIPS-197 standard**. 

This repository is currently in active development. The foundational logic has been verified against a Python Golden Model.

## ✨ Current Features
* **AES-128 Core Logic:** Complete Verilog implementation of the four standard transformations: `SubBytes` (S-Box), `ShiftRows`, `MixColumns`, and `AddRoundKey`.
* **Python Golden Model:** A software reference model used to generate standard FIPS-197 test vectors, ensuring the hardware simulation produces bit-perfect ciphertexts.
* **Modular RTL Design:** Clean, hierarchical Verilog codebase designed for easy testing, debugging, and future architectural upgrades.



## 🚀 Roadmap (Upcoming Features)
* [x] **Python Golden Model:** Integrated a mathematical reference model for generating expected test vectors.
* [ ] **Pipelined Architecture:** Upgrading the core to a 10-stage hardware pipeline by inserting registers between rounds to maximize maximum clock frequency (Fmax) and achieve a throughput of 1 block per clock cycle.
* [ ] **UART Interface:** Developing a custom Finite State Machine (FSM) to handle serial data transmission between the FPGA and a host PC.
* [ ] **MATLAB GUI Dashboard:** Building an interactive software front-end to load `.bmp`/`.png` images, send them to the FPGA, and display the hardware-encrypted results in real-time.

    
     Final Flowchart
     ![Flowchart](https://github.com/user-attachments/assets/c70c0865-c00e-416e-8fc4-bd6407e429c4)


## 📂 Repository Structure
```text
📦 AES128-FPGA-Accelerator
 ┣ 📂 rtl             # Synthesizable Verilog source files (Core AES modules)
 ┣ 📂 software        # Python Golden Model for generating test vectors
 ┣ 📂 tb              # Verilog testbenches for behavioral simulation
 ┗ 📜 README.md       # Project documentation
