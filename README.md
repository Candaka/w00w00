# Decentralized Social Media Platform

This is a decentralized social media platform built using the **Internet Computer Protocol (ICP)**. The platform allows users to:
- Create posts with content and uploaded files.
- Like posts.
- Add comments to posts.

## Features
1. **Decentralized Backend**: Powered by ICP's canister smart contracts.
2. **Upload Files**: Attach file URLs (e.g., images or documents) to posts.
3. **Likes and Comments**: Enable user interaction on posts.
4. **Frontend with React.js**: A simple and modern interface.

---

## **Technologies Used**
- **ICP (Internet Computer Protocol)**:
  - Backend is built with **Motoko**.
  - Canister management using `dfx` CLI.
- **React.js**:
  - Frontend interface for users.
  - Communicates with ICP backend via the `@dfinity/agent` library.

---

## **Getting Started**

### Prerequisites
- Install the **DFX CLI** for ICP development:
  ```bash
  sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
- Install Nodejs and Npm for frontend development
  [Nodejs official] (https://nodejs.org/en)
  ![nodejs] (https://palcomtech.ac.id/node-js-memahami-dasar-dasar-dan-proses-instalasi/)
