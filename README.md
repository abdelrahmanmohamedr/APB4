# AMBA APB4 Protocol Implementation and Verification

This repository contains comprehensive documentation and implementation details for the AMBA® APB4 Protocol. The project covers the full design and verification of the APB interface, including master and slave implementations, an APB wrapper, and its verification environment using UVM (Universal Verification Methodology).

## Table of Contents
1. [Overview](#overview)  
2. [AMBA APB4 Specifications](#amba-apb4-specifications)  
   - [Signals](#signals)  
   - [Transfers](#transfers)  
   - [Functionalities](#functionalities)  
3. [Master APB Interface](#master-apb-interface)  
   - [Verilog Code](#verilog-code-master)  
   - [RTL Analysis and Synthesis](#rtl-analysis-and-synthesis-master)  
   - [Static Timing and Utilization Reports](#static-timing-and-utilization-reports-master)  
   - [Implementation Schematic](#implementation-schematic-master)  
4. [Slave APB Interface](#slave-apb-interface)  
   - [Verilog Code](#verilog-code-slave)  
   - [RTL Analysis and Synthesis](#rtl-analysis-and-synthesis-slave)  
   - [Static Timing and Utilization Reports](#static-timing-and-utilization-reports-slave)  
   - [Implementation Schematic](#implementation-schematic-slave)  
5. [APB Wrapper](#apb-wrapper)  
   - [Verilog Code](#verilog-code-wrapper)  
   - [RTL Analysis and Synthesis](#rtl-analysis-and-synthesis-wrapper)  
   - [Static Timing and Utilization Reports](#static-timing-and-utilization-reports-wrapper)  
   - [Implementation Schematic](#implementation-schematic-wrapper)  
6. [APB Wrapper Verification](#apb-wrapper-verification)  
   - [UVM Verification Plan and Components](#uvm-verification-plan-and-components)  
   - [Simulation and Coverage Results](#simulation-and-coverage-results)  
7. [References](#references)
   
---

## Overview

This project provides a detailed implementation and verification of the AMBA APB4 protocol. It includes:

- **Protocol Specifications:** A comprehensive explanation of signal definitions, timing transfers (for both read and write transactions), and key functionalities such as write strobe and protection unit support.
- **Interface Implementations:** Detailed Verilog code, RTL schematics, synthesis analyses, static timing analysis, and utilization reports for both master and slave APB interfaces.
- **APB Wrapper:** A wrapper module that integrates the master and slave interfaces, along with associated schematics and timing reports.
- **Verification Environment:** A full UVM-based verification environment covering all phases including sequence items, sequencers, reset sequences, main sequences, and coverage analysis. Simulation results and 100% code and functional coverage are provided.

---

## AMBA APB4 Specifications

### Signals
Introduces the key signals used in the APB4 protocol, covering signal names, their roles in the protocol, and how they interact during various phases of the transfer.

### Transfers
The APB4 protocol defines several transfer types:

- **Write Transfers (with and without waiting):**
    - **T1 (Setup Phase):** The master registers the address (PADDR), write data (PWDATA), write signal (PWRITE), and select signal (PSEL).  
    - **T2 (Beginning of Access Phase):** The enable (PENABLE) and ready (PREADY) signals are registered. In non-waiting transfers, PREADY is asserted immediately.  
    - **T3 (End of Access Phase):** Transfer completion is indicated by the deassertion of PENABLE (and PSEL if no immediate subsequent transfer is scheduled).  

- **Read Transfers (with and without waiting):**
    - Similar phases are followed as in write transfers, with the key difference being that data is read from the slave instead of written.

### Functionalities
- **Write Strobe (PSTRB):** Controls byte-level enable signals for the write data bus, indicating which byte lanes contain valid data.  
- **Protection Unit Support:** Offers enhanced control mechanisms ensuring the integrity of data transfers in secure environments.

---

## Master APB Interface

### Verilog Code (Master)
The master interface module is implemented in Verilog. This code includes all the necessary registers, signal definitions, and state machines required to drive APB transactions.

### RTL Analysis and Synthesis (Master)
- **RTL Analysis:** Provides a breakdown of the register-transfer level behavior and timing.
- **Synthesis Schematic:** Visually represents the logic implemented in hardware, detailing the connectivity and structure.

### Static Timing and Utilization Reports (Master)
- **Static Timing Analysis:** Verifies that the design meets the necessary timing constraints.
- **Utilization Reports:** Outlines the resource consumption for the master interface in the target hardware.

### Implementation Schematic (Master)
A clear schematic diagram that shows the integration of various master interface blocks.

---

## Slave APB Interface

### Verilog Code (Slave)
Contains the Verilog implementation of the slave APB interface including registers, data handling, and control logic.

### RTL Analysis and Synthesis (Slave)
- **RTL Analysis:** Explanation of the slave interface's register-transfer level design.  
- **Synthesis Schematic:** Illustrative schematic showing how the logic maps to physical hardware.  

### Static Timing and Utilization Reports (Slave)
- **Static Timing Analysis:** Confirms that the slave logic adheres to the timing requirements.  
- **Utilization Reports:** Detailed resource usage statistics.  

### Implementation Schematic (Slave)
A visual schematic representing the physical design and connections in the slave interface module.

---

## APB Wrapper

### Verilog Code (Wrapper)
Provides the Verilog code for the APB wrapper module that interconnects the master and slave APB interfaces, ensuring compatibility and proper signal routing.

### RTL Analysis and Synthesis (Wrapper)
- **RTL Analysis:** Details the internal functioning and high-level structure of the APB wrapper.  
- **Synthesis Schematic:** Diagrammatic representation of the wrapper's logical architecture.  

### Static Timing and Utilization Reports (Wrapper)
These reports validate that the APB wrapper meets all timing constraints and efficiently utilizes hardware resources.

### Implementation Schematic (Wrapper)
A schematic layout showing how the APB wrapper module is implemented in the overall design.

---

## APB Wrapper Verification

### UVM Verification Plan and Components
This section details the UVM-based verification plan:

- **Sequence_item:** Defines the transactions.  
- **Sequencer:** Manages sequence items.  
- **Reset Sequence:** Handles system resets.  
- **Main Sequence:** Drives primary test scenarios.  
- **Coverage Analysis:** Ensures all functional scenarios are tested.  
- **Scoreboard, Driver, and Monitor:** Monitor and verify signal integrity and protocol conformance.  
- **UVM Agent and Environment:** Encapsulates the entire verification setup.  
- **Configuration Object, APB Interface, and Top-Level Integration:** Provide additional testing layers.

### Simulation and Coverage Results
Simulation results confirm the proper function of the APB protocol implementation, achieving 100% functional coverage and 100% code coverage.

---

## References
- **AMBA® APB Protocol Version 2.0**  
Published by ARM, this document serves as the primary reference for the protocol specifications and design guidelines.
