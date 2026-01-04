ChatGPT developed, but here as a wishlist for reference:

# Azure VM Control Tool (PowerShell)

A structured, professional PowerShell tool for safely managing Azure Virtual Machines from the command line.

This project is intentionally built **as an internal SRE / Cloud Ops utility**, focusing on clarity, safety, and maintainability rather than flashy UI.

---

## 🎯 Project Goals

* Provide a **safe, interactive control surface** for Azure VM operations
* Make current context (subscription, RG, VM, status) **always visible**
* Reduce operational mistakes through guardrails and validation
* Serve as a foundation for future GUI or web frontends

---

## 🧱 Design Principles

* Terminal-first (works in Cloud Shell / jump boxes)
* Explicit state and context
* Minimal dependencies
* Human-friendly UX
* Production-minded error handling

---

## 🗂 Feature Roadmap

The roadmap is organised into tiers. Each tier builds on the previous one.

> ⚠️ **Not all tiers are required**. Tier 1–3 already represent a strong, professional internal tool.

---

## ✅ Tier 1 — Core UX & Safety

**Objective:** Make the tool clear, safe, and predictable to use.

### Context & Visibility

* [ ] Persistent context header displayed on every menu refresh

  * Subscription name
  * Resource Group
  * VM name
  * VM power state
* [ ] Clear visual separator under the header
* [ ] VM status refreshed after every action

### Input Control

* [ ] Replace free-text Resource Group input with numbered selection
* [ ] Replace free-text VM input with numbered selection
* [ ] Menu input validation (numbers only, valid range)
* [ ] Re-prompt on invalid selections

### Flow Control

* [ ] Single main menu loop
* [ ] Dedicated path to change context (subscription / RG / VM)
* [ ] Clean and predictable exit behaviour

---

## ✅ Tier 2 — Code Quality & Maintainability

**Objective:** Separate concerns and make the tool extensible.

### Structure

* [ ] Remove `$global:` variables
* [ ] Introduce a single `$Context` object for state management
* [ ] Extract Azure actions into dedicated functions:

  * `Start-VM`
  * `Stop-VM`
  * `Restart-VM`
  * `Get-VMStatus`
  * `Select-Context`
* [ ] Menu logic only calls functions (no embedded Azure logic)

### Error Handling

* [ ] Centralised error handling strategy
* [ ] Use `-ErrorAction Stop` consistently
* [ ] Display user-friendly errors in UI
* [ ] Log detailed exception data instead of printing it

---

## ✅ Tier 3 — Safety & Guardrails

**Objective:** Prevent accidental or unsafe operations.

### Destructive Action Protection

* [ ] Confirmation prompt before Stop / Restart actions
* [ ] Confirmation message displays VM name and Resource Group
* [ ] Optional `-WhatIf` / dry-run mode

### State Awareness

* [ ] Block Start if VM is already running
* [ ] Block Stop if VM is already stopped
* [ ] Warn if VM is in a transitional state (Starting / Stopping)

---

## ✅ Tier 4 — Observability & Audit

**Objective:** Make actions traceable and auditable.

### Logging

* [ ] Log file created on first execution
* [ ] Log entries include:

  * Timestamp
  * Executing user
  * Subscription
  * Resource Group
  * VM name
  * Action performed
  * Result (Success / Failure)
* [ ] Logs append (never overwrite)

### Output Discipline

* [ ] Clean, consistent user-facing messages
* [ ] Detailed errors written only to logs
* [ ] Status messages standardised across actions

---

## ✅ Tier 5 — UX Polish (Optional)

**Objective:** Improve confidence and usability without changing behaviour.

### Visual Polish

* [ ] Colour-coded VM status

  * Running = Green
  * Stopped = Yellow
  * Error = Red
* [ ] Clear success and failure confirmations
* [ ] Minimal screen flicker during refresh

### Navigation

* [ ] "Back to menu" option available everywhere
* [ ] No dead ends in the menu flow
* [ ] Help / Info screen describing tool purpose

---

## ✅ Tier 6 — Extensibility (Future)

**Objective:** Prepare the tool for scale or alternate interfaces.

### Features

* [ ] Multi-VM selection
* [ ] Tag-based VM filtering
* [ ] Start/Stop scheduling support
* [ ] Export VM status to CSV
* [ ] Role-based restrictions (read-only vs control)

### Evolution

* [ ] Script supports non-interactive execution
* [ ] Core functions callable by external apps
* [ ] Ready to be wrapped by GUI or web frontend

---

## 🚀 Usage Strategy

This tool is intentionally built **incrementally**.

Recommended approach:

1. Implement 2–3 items per tier
2. Commit changes
3. Move forward — do not overbuild

Completion > perfection.

---

## 📌 Status

This project is under active development.

Current focus:

* Tier 1 (Context Header + Input Control)

---

## 📄 License

Internal / Educational use.
