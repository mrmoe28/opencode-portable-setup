# Pattern: OpenCode Global Code Memory

Date: {{DATE}}
Project: global OpenCode setup
Stack: OpenCode, Markdown vault
Status: worked

## Problem

OpenCode should remember coding fixes across future sessions and projects.

## Cause

OpenCode can resume sessions and load instruction files, but it does not train model weights from local work.

## Action

Use a global code memory folder organized into `fixes`, `patterns`, `failures`, `projects`, and `pending`.

OpenCode should consult this folder before similar coding tasks and update it after meaningful fixes, failed attempts, or reusable implementation discoveries.

## Verification

The folder is created and the OpenCode global config points at the vault.

## Reuse Notes

Use this pattern for long-lived coding memory. Keep entries brief and searchable. Store lessons and file pointers, not full transcripts.

