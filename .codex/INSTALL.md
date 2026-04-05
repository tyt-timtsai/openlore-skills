# Installing OpenLore Skills for Codex

## Prerequisites

- `openlore-mcp` binary installed and in PATH
- Git

## Installation

1. **Clone the skills repository:**
   ```bash
   git clone https://github.com/openlore/openlore-skills.git ~/.codex/openlore-skills
   ```

2. **Create the skills symlink:**
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/openlore-skills/skills ~/.agents/skills/openlore
   ```

3. **Restart Codex** to discover the skills.

## Verify

```bash
ls -la ~/.agents/skills/openlore
```

You should see a symlink pointing to your openlore-skills/skills directory.

## Updating

```bash
cd ~/.codex/openlore-skills && git pull
```

Skills update instantly through the symlink.

## Uninstalling

```bash
rm ~/.agents/skills/openlore
rm -rf ~/.codex/openlore-skills
```
