# 《命》 Architecture Document

**Engine**: Godot 4.6.3
**Language**: GDScript
**Status**: MVP

## Core Architecture

### Autoload Singletons

| Singleton | Path | Purpose |
|-----------|------|---------|
| GameState | scripts/core/GameState.gd | Global state (stats, age, events) |
| TimeManager | scripts/core/TimeManager.gd | Day/night + age progression |
| EventEngine | scripts/core/EventEngine.gd | Event trigger & execution |
| SaveSystem | scripts/core/SaveSystem.gd | Save/Load |

### Scene Structure

```
scenes/
├── Main.tscn              # Main game scene
├── Town.tscn              # Town map (outdoor)
├── Home.tscn              # Player's home
├── HomeInterior.tscn      # Home interior
├── School.tscn            # School
├── SchoolInterior.tscn    # Classroom
├── OldTree.tscn           # Old tree gathering spot
├── Shop.tscn              # Shop (Dazhuang's family)
├── player/
│   └── Player.tscn        # CharacterBody2D
├── npcs/
│   └── NPC.tscn           # NPC base scene
├── ui/
│   ├── HUD.tscn           # HUD overlay
│   ├── DialogueBox.tscn   # Dialogue UI
│   ├── StatsPanel.tscn    # Stats display
│   └── FateBook.tscn      # Fate book UI
└── minigames/
    └── Exam.tscn          # Exam minigame
```

### Data Structure

```
data/
├── events/
│   ├── childhood.json     # Events for age 7-12
│   └── teen.json          # Events for age 12-18
├── npcs/
│   ├── xiaogang.json      # Xiao Gang's schedule & dialogue
│   └── xiaofang.json      # Xiao Fang's schedule & dialogue
├── dialogues/
│   └── *.json             # Dialogue trees
└── backgrounds.json       # Birth backgrounds
```

### Layer Architecture

1. **Foundation**: PlayerControl, TimeSystem, SceneManagement
2. **Core**: EventEngine, NPCSchedule, Dialogue, TownLife, Save
3. **Feature**: FateSystem, LifeNode, NPCParallelLife, Minigame
4. **Presentation**: HUD, DialogueBox, StatsPanel, FateBook

### Key Design Decisions

1. **Data-driven**: All events, dialogues, NPC schedules in JSON
2. **Signal-based**: Systems communicate via Godot signals
3. **Autoload singletons**: Core systems as global singletons
4. **Scene-based**: Each area is a separate scene
