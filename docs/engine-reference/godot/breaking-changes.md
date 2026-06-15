# Godot — Breaking Changes

Version-by-version breaking changes from training data cutoff (~4.3/4.4) to pinned version (4.6.3).

Last verified: 2026-06-15

---

## Godot 4.5 (2025-09-15) — Feature Release

### TileMap / TileMapLayer
- TileMapLayer continued stabilization — check for API changes if migrating from 4.3/4.4
- TileMap editor overlay behavior changes

### Animation
- AnimationPlayer improvements — verify signal behavior
- AnimationNodeStateMachine transition reconnection support
- Tween.kill() now propagates to subtweens

### Physics
- Physics server modifications — verify collision/raycast API signatures

### GDExtension
- GDExtension API updates — native plugins may need recompilation

---

## Godot 4.6 (2026-01-26) — Feature Release

### 2D
- `CanvasItem::draw_set_transform` rotation/scale order fix — verify draw calls
- `Camera2D` limit checks for inverted boundaries changed

### 3D
- Select Mode renamed to Transform Mode (new Select Mode without transform gizmo)
- `Node3D.global_rotation` now derived from orthonormalized global basis
- Default 3D editor changed to Transform mode (restores 4.5 behavior)

### Animation
- `AnimationLibrary` serialization changed — no longer uses Dictionary
- `AnimationPlayer` uses StringName instead of String in exposed API
- `AnimationNodeStateMachinePlayback` default state changed to Start
- Tween propagation changes (subtweens)

### C#
- GodotTools .NET version updated from 6.0 to 8.0
- Visual Studio 2026 support added
- Source generator fixes — may affect code generation
- `FileAccess::create_temp()` now uses `FileAccess::ModeFlags`

### TileMap
- `TileMapLayer` pattern corruption fix
- Scene tile rotation support added
- Undo/redo memory usage reduced

### GDExtension
- Various API stabilization changes

---

## Godot 4.6.1 — 4.6.3 (Maintenance)

Maintenance releases — compatible with 4.6, no breaking changes expected.
Bug fixes only.

---

## Migration Checklist (4.3/4.4 → 4.6.3)

- [ ] Verify all TileMap/TileMapLayer API usage
- [ ] Check AnimationPlayer signal behavior
- [ ] Verify C# .NET 8.0 compatibility
- [ ] Test GDExtension plugins (if any) against 4.6 API
- [ ] Verify draw_set_transform call order in 2D code
- [ ] Check Camera2D limit behavior
- [ ] Review AnimationLibrary serialization if loading custom data
