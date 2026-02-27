# x86-car-game

A real-time 2D endless driving game built entirely in x86-64 assembly, featuring direct VGA graphics (Mode 13h), a custom game loop, collision detection, and dynamic difficulty scaling.

---

## Overview

This project is a low-level arcade-style game where the player controls a car on a three-lane highway and avoids incoming traffic for as long as possible.

It runs in a bootable environment provided by the course and is written entirely in assembly. All rendering, input handling, and game logic are implemented without high-level libraries or frameworks.

---

## Gameplay

- Move left and right between three lanes  
- Avoid incoming traffic  
- The longer you survive, the faster the game becomes  
- Endless gameplay focused on achieving a high score  

---

## Technical Highlights

- Written in x86-64 assembly (NASM)  
- Runs in a bootable gamelib-x64 environment  
- VGA Mode 13h (320×200, 256 colors)  
- Direct framebuffer memory access  
- Custom game loop (~70 FPS, synchronized with vertical retrace)  
- Linear Congruential Generator (LCG) for randomness  
- Memory footprint under 1KB  

---

## Controls

- Left / Right arrow keys or A / D — move between lanes  
- ESC — quit the game  

---

## Game Mechanics

- Player car remains at a fixed vertical position and switches between three lanes  
- Traffic cars spawn at the top and move downward  
- Maximum of 10 traffic cars on screen at once  
- Collision occurs when the player and a traffic car overlap in the same lane  

---

## Scoring and Difficulty

- Score increases over time  
- Initially increments every 5 frames  
- Every 20 points, the game speed increases  
- Minimum interval is 2 frames  

---

## High Scores

- Top 5 scores are stored in memory  
- Scores persist until reboot  
- Automatically ranked after each game  

---

## Running the Game

This project runs in the course-provided gamelib-x64 environment.

Example build process:

```bash
nasm -f elf64 game.asm -o game.o
ld game.o -o game.bin
