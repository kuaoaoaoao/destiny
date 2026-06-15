# Godot — Version Reference

| Field | Value |
|-------|-------|
| **Engine Version** | 4.6.3-stable |
| **Project Pinned** | 2026-06-15 |
| **LLM Knowledge Cutoff** | May 2025 (~Godot 4.3/4.4) |
| **Risk Level** | HIGH — version is beyond LLM training data |
| **Language** | GDScript + C# (.NET 8+) |

## Post-Cutoff Version Timeline

| Version | Release Date | Type | Status |
|---------|-------------|------|--------|
| 4.4.1 | 2025-03-26 | Maintenance | Within training data |
| 4.5 | 2025-09-15 | Feature | Beyond training data |
| 4.5.1 | 2025-10-15 | Maintenance | Beyond training data |
| 4.5.2 | 2026-03-19 | Maintenance | Beyond training data |
| 4.6 | 2026-01-26 | Feature | Beyond training data |
| 4.6.1 | 2026-02-16 | Maintenance | Beyond training data |
| 4.6.2 | 2026-04-01 | Maintenance | Beyond training data |
| 4.6.3 | 2026-05-20 | Maintenance | **Pinned version** |

## Knowledge Gap Analysis

This project uses Godot 4.6.3, which is approximately **2 feature releases** beyond the LLM's training data. This means:

1. **APIs may have changed** — agents should verify API signatures before suggesting code
2. **New features exist** — agents may not know about 4.5/4.6 additions
3. **Deprecated APIs** — agents may suggest APIs that have been deprecated or removed

## Mitigation

- Agents should read this file and `deprecated-apis.md` before writing code
- Use `WebSearch` to verify uncertain API calls against official Godot 4.6 docs
- Check `breaking-changes.md` for version-specific migration notes
- Official migration guides:
  - [Upgrading to Godot 4.5](https://docs.godotengine.org/en/4.5/tutorials/migrating/upgrading_to_godot_4.5.html)
  - [Upgrading to Godot 4.6](https://docs.godotengine.org/en/4.6/tutorials/migrating/upgrading_to_godot_4.6.html)

## Key 4.5 Features (2025-09-15)

- TileMapLayer improvements and stability
- GDScript enhancements
- Animation system improvements
- Physics server modifications
- GDExtension updates

## Key 4.6 Features (2026-01-26)

- TileMap: Scene tile rotation, improved editor, reduced undo/redo memory
- Animation: New IK modifiers, bezier editor improvements, Tween propagation
- C#: .NET 8.0 update, Visual Studio 2026 support, source generator fixes
- 2D: Local space editing, Polygon2D editor improvements
- 3D: Transform mode, orbit snapping, improved gizmos
- Rendering: Various fixes and optimizations
- GDExtension: Continued API stabilization

## Verification

Last verified: 2026-06-15 via GitHub API (godotengine/godot releases).
