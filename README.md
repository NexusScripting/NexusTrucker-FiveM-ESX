# Simple Trucking Logistics

A lightweight and configurable trucking job script for FiveM. This script allows players to take on delivery missions, earn XP, and unlock higher-tier jobs.

## 🚀 Features
* **Leveling System:** Progress through Standard, Heavy, and Hazmat tiers.
* **XP Rewards:** Earn experience points based on delivery difficulty.
* **Dynamic Spawning:** Vehicles and trailers spawn at predefined coordinates.
* **Configurable:** Fully customizable locations, prices, and job types via `config.lua`.

## 🛠️ Installation
1.  Download the resource and place it into your `resources` folder.
2.  Add `ensure NexusTrucker` to your `server.cfg`.
3.  Adjust the locations and job parameters in the `config.lua` to fit your map.

## 📁 Configuration
The script uses a `vector3` setup for all major coordinates:
* **DepotLocation:** The main interaction point for workers.
* **SpawnPoints:** A list of coordinates and headings for vehicle generation.
* **Jobs:** Define `minLevel`, `basePrice`, and `xpReward` for each mission.

## 🚛 Delivery Points
The script currently supports multiple delivery locations across San Andreas, which can be easily expanded in the `Config.DeliveryPoints` table.

---
*Developed for FiveM Servers - 2026*