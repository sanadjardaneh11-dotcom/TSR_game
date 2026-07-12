class_name DamageCalculations
extends Resource

func damge(damage,armor) -> float:
	return damage/((armor/100)+1)
