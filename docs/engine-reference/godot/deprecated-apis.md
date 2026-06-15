# Godot — Deprecated APIs

"Don't use X → Use Y" reference for APIs deprecated between training data cutoff (~4.3/4.4) and pinned version (4.6.3).

Last verified: 2026-06-15

---

## Animation

| Deprecated | Replacement | Version |
|------------|-------------|---------|
| AnimationLibrary Dictionary serialization | New binary serialization format | 4.6 |
| AnimationPlayer String-based API | StringName-based API | 4.6 |

## C#

| Deprecated | Replacement | Version |
|------------|-------------|---------|
| .NET 6.0 targeting | .NET 8.0 (required for GodotTools) | 4.6 |
| Old source generator patterns | Updated source generators | 4.6 |

## 3D

| Deprecated | Replacement | Version |
|------------|-------------|---------|
| "Select Mode" (with transform gizmo) | "Transform Mode" (renamed) | 4.6 |
| Old rotation gizmo behavior | New rotation arc + 4th handle | 4.6 |

## TileMap

| Deprecated | Replacement | Version |
|------------|-------------|---------|
| Old TileMap editor overlay | New fade-on-zoom overlay | 4.6 |

---

## General Guidance

When in doubt about an API:
1. Check the official Godot 4.6 class documentation: https://docs.godotengine.org/en/4.6/classes/
2. Search for the specific class/method in the docs
3. If a method is marked as deprecated, the docs will suggest the replacement
4. Use WebSearch to verify: "Godot 4.6 [class name] [method name]"
