# 🎡 Roblox Spin Wheel System

A professional, secure, and fully animated Spin Wheel system for Roblox. This system is designed to be "plug-and-play" while maintaining high-security standards by handling all rewards and probability on the server side.

---

### 🌟 Key Features

*   **Server-Side Security**: All reward calculations happen on the server to prevent players from cheating or exploiting the wheel.
*   **Luck Multiplier System**: Includes a built-in "Double Luck" feature. It automatically detects if a player owns a specific GamePass and doubles their chances for rare rewards.
*   **Smooth UI Animations**: Uses **TweenService** for high-quality visual feedback, including spinning physics, hover effects, and "pop-up" reward notifications.
*   **Monetization Ready**: Integrated with **MarketplaceService** for easy purchasing of extra spins or luck boosts.
*   **Data Consistency**: Uses **DataStore2** logic to ensure player spins and rewards are saved reliably.

---

### 🛠️ How it Works

1.  **Request**: The player clicks "SPIN" on the client side.
2.  **Verification**: The server checks if the player has enough spins. If not, it prompts a purchase.
3.  **Calculation**: The server picks a reward based on a weighted percentage system (adjusted by luck passes).
4.  **Visuals**: The server tells the client which reward was picked. The client then triggers a 4.5-second smooth spin animation to match the result.
5.  **Reward**: After the animation finishes, the server grants the actual item (Coins, Skips, or Pets) to the player's inventory.

---

### 📂 Technical Stack

*   **Language**: Luau.
*   **Workflow**: Developed using **VS Code** and **Rojo** for clean, modular code management.
*   **Dependencies**: DataStore2, TweenService, MarketplaceService.

The output:
https://github.com/user-attachments/assets/75809a6b-395a-48a1-aba9-a0fcb0d1fcb6



