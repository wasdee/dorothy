#!/usr/bin/env xonsh

# https://rsteube.github.io/carapace-bin/setup.html#xonsh
if !(command-exists starship).returncode == 0:
	COMPLETIONS_CONFIRM=True
	exec($(carapace _carapace))
